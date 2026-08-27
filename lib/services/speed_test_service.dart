import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:net_chui/models/ping_stats.dart';
import 'package:net_chui/models/speed_test_config.dart';
import 'package:net_chui/models/speed_test_phase.dart';
import 'package:net_chui/models/speed_test_result.dart';
import 'package:net_chui/models/speed_test_server.dart';
import 'package:net_chui/models/test_mode.dart';
import 'package:net_chui/services/ip_info_service.dart';
import 'package:net_chui/services/haptic_service.dart';

typedef SpeedTestProgress = void Function(
  SpeedTestPhase phase, {
  double? liveMbps,
  double? livePingMs,
  SpeedTestResult? partial,
});

class SpeedTestService {
  SpeedTestService({
    http.Client? client,
    IpInfoService? ipInfoService,
  })  : _client = client ?? http.Client(),
        _ipInfo = ipInfoService ?? IpInfoService();

  static const _pingSamples = 5;
  static const _warmupBytes = 256 * 1024;

  final http.Client _client;
  final IpInfoService _ipInfo;

  Future<SpeedTestResult> runTest({
    required SpeedTestConfig config,
    required SpeedTestProgress onProgress,
    required bool Function() isCancelled,
  }) async {
    var result = const SpeedTestResult();
    var testConfig = config;

    // 1. Best Server Selection
    if (config.server.id == 'auto') {
      onProgress(SpeedTestPhase.ping);
      try {
        final bestServer = await _findBestServer(isCancelled);
        if (isCancelled()) return result;
        testConfig = config.copyWith(server: bestServer);
      } catch (e) {
        // Fallback to Cloudflare if auto-selection fails
        testConfig = config.copyWith(server: SpeedTestServer.cloudflare);
      }
    }

    final mode = testConfig.mode;
    final server = testConfig.server;

    List<String> fastDownloadUrls = [];
    if (server.isFastApi) {
      try {
        final response = await _client.get(Uri.parse(server.pingUrl));
        final data = json.decode(response.body);
        if (data['targets'] != null) {
          fastDownloadUrls = (data['targets'] as List).map((t) => t['url'] as String).toList();
        }
      } catch (e) {
        // Fallback or handle error
      }
    }

    // 2. Ping & Jitter
    if (mode == TestMode.full || mode == TestMode.pingOnly) {
      onProgress(SpeedTestPhase.ping);
      HapticService.light();
      final stats = await _measurePing(
        pingUrl: server.pingUrl,
        onSample: (avg) => onProgress(
          SpeedTestPhase.ping,
          livePingMs: avg,
          partial: result.copyWith(pingMs: avg),
        ),
        isCancelled: isCancelled,
      );
      if (isCancelled()) return result;
      
      if (stats.avgMs >= 999) {
        throw const SpeedTestException('Ping measurement failed. Check your network connection.');
      }

      result = result.copyWith(
        pingMs: stats.avgMs,
        pingMinMs: stats.minMs,
        pingMaxMs: stats.maxMs,
        jitterMs: stats.jitterMs,
      );
      onProgress(SpeedTestPhase.ping, partial: result);

      // ISP & GeoIP Detection
      final ipInfo = await _ipInfo.fetchFromTrace(server.pingUrl);
      if (!isCancelled()) {
        result = result.copyWith(
          publicIp: ipInfo.ip,
          locationHint: ipInfo.location,
          isp: ipInfo.isp,
          countryCode: ipInfo.countryCode,
        );
      }
    }

    // 3. Download + Loaded Latency
    if (mode == TestMode.full || mode == TestMode.downloadOnly) {
      if (isCancelled()) return result;
      onProgress(SpeedTestPhase.download);
      HapticService.light();
      await _warmupDownload(testConfig, isCancelled);
      if (isCancelled()) return result;

      final downResult = await _measureDownloadWithLatency(
        config: testConfig,
        fastUrls: fastDownloadUrls,
        onProgress: (mbps) => onProgress(
          SpeedTestPhase.download,
          liveMbps: mbps,
          partial: result.copyWith(downloadMbps: mbps),
        ),
        isCancelled: isCancelled,
      );
      if (isCancelled()) return result;
      result = result.copyWith(
        downloadMbps: downResult.speedMbps,
        downloadPingMs: downResult.loadedLatencyMs,
      );
      onProgress(SpeedTestPhase.download, partial: result);
    }

    // 4. Upload + Loaded Latency
    if (mode == TestMode.full || mode == TestMode.uploadOnly) {
      if (isCancelled()) return result;
      onProgress(SpeedTestPhase.upload);
      HapticService.light();
      final upResult = await _measureUploadWithLatency(
        config: testConfig,
        onProgress: (mbps) => onProgress(
          SpeedTestPhase.upload,
          liveMbps: mbps,
          partial: result.copyWith(uploadMbps: mbps),
        ),
        isCancelled: isCancelled,
      );
      if (isCancelled()) return result;
      result = result.copyWith(
        uploadMbps: upResult.speedMbps,
        uploadPingMs: upResult.loadedLatencyMs,
      );
    }

    onProgress(SpeedTestPhase.done, partial: result);
    HapticService.success();
    return result;
  }

  Future<SpeedTestServer> _findBestServer(bool Function() isCancelled) async {
    final candidates = SpeedTestServer.all.where((s) => s.id != 'auto').toList();
    if (candidates.isEmpty) return SpeedTestServer.cloudflare;

    final latencies = await Future.wait(candidates.map((s) async {
      if (isCancelled()) return 9999;
      try {
        // We do 2 pings and take the minimum to avoid cold-start outliers
        int minLat = 9999;
        for (int i = 0; i < 2; i++) {
          if (isCancelled()) break;
          final start = DateTime.now();
          // Use a HEAD request if possible, or a small GET
          final uri = Uri.parse(s.pingUrl);
          await _client.get(uri).timeout(const Duration(seconds: 1));
          final lat = DateTime.now().difference(start).inMilliseconds;
          if (lat < minLat) minLat = lat;
        }
        return minLat;
      } on Object {
        return 9999;
      }
    }));

    var bestIdx = 0;
    for (var i = 1; i < latencies.length; i++) {
      if (latencies[i] < latencies[bestIdx]) {
        bestIdx = i;
      }
    }

    // Fallback to cloudflare if all candidates timed out or failed
    if (latencies[bestIdx] >= 9999) return SpeedTestServer.cloudflare;

    return candidates[bestIdx];
  }

  Future<void> _warmupDownload(
    SpeedTestConfig config,
    bool Function() isCancelled,
  ) async {
    if (isCancelled()) return;
    final bytes = min(_warmupBytes, config.downloadBytes ~/ 4);
    final uri = Uri.parse(config.server.downloadUrlBuilder(bytes));
    try {
      final streamed = await _client.send(http.Request('GET', uri)).timeout(
            const Duration(seconds: 15),
          );
      await streamed.stream.drain();
    } on Object {
      // Warmup failed, ignore
    }
  }

  Future<PingStats> _measurePing({
    required String pingUrl,
    required void Function(double avgMs) onSample,
    required bool Function() isCancelled,
  }) async {
    final samples = <double>[];
    for (var i = 0; i < _pingSamples; i++) {
      if (isCancelled()) break;
      final start = DateTime.now();
      try {
        await _client
            .get(Uri.parse(pingUrl))
            .timeout(const Duration(seconds: 3));
        
        final ms = DateTime.now().difference(start).inMicroseconds / 1000.0;
        samples.add(ms);
        onSample(PingStats.fromSamples(samples).avgMs);
      } on Object {
        // Sample failed, ignore
      }
      if (i < _pingSamples - 1) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    if (samples.isEmpty) {
      // Return a default bad ping instead of throwing to avoid crashing the test
      return const PingStats(avgMs: 999, minMs: 999, maxMs: 999, jitterMs: 0, samples: 0);
    }
    return PingStats.fromSamples(samples);
  }

  Future<_PhaseResult> _measureDownloadWithLatency({
    required SpeedTestConfig config,
    required void Function(double mbps) onProgress,
    required bool Function() isCancelled,
    List<String> fastUrls = const [],
  }) async {
    final parallelStreams = fastUrls.isNotEmpty ? fastUrls.length : 4;
    final bytesPerStream = config.downloadBytes ~/ parallelStreams;
    final stopwatch = Stopwatch()..start();
    var totalReceived = 0;
    double? loadedLatency;

    final latencyFuture = () async {
      try {
        final pingUrl = fastUrls.isNotEmpty ? fastUrls.first : config.server.pingUrl;
        final s = await _measurePing(
          pingUrl: pingUrl,
          onSample: (_) {},
          isCancelled: isCancelled,
        );
        loadedLatency = s.avgMs;
      } on Object {
        // Latency measurement failed
      }
    }();

    var successCount = 0;
    final streamFutures = List.generate(parallelStreams, (index) async {
      try {
        final url = fastUrls.isNotEmpty 
            ? fastUrls[index] 
            : config.server.downloadUrlBuilder(bytesPerStream);
        
        final response = await _client.send(http.Request('GET', Uri.parse(url))).timeout(const Duration(seconds: 30));
        
        if (response.statusCode >= 400) return;

        await for (final chunk in response.stream) {
          if (isCancelled()) break;
          totalReceived += chunk.length;
          successCount++; // Mark that we at least got some data
          final elapsed = stopwatch.elapsedMicroseconds / 1e6;
          if (elapsed > 0) {
            onProgress(_bytesToMbps(totalReceived, elapsed));
          }
          
          if (!fastUrls.isNotEmpty && totalReceived >= config.downloadBytes) break;
          if (fastUrls.isNotEmpty && totalReceived >= (config.downloadBytes * 2)) break;
        }
      } on Object catch (e) {
        debugPrint('Download stream $index failed: $e');
      }
    });

    await Future.wait([...streamFutures, latencyFuture]);
    stopwatch.stop();

    if (totalReceived == 0 && successCount == 0 && !isCancelled()) {
      throw const SpeedTestException('Download failed. Please check your internet connection.');
    }

    return _PhaseResult(
      speedMbps: _bytesToMbps(totalReceived, stopwatch.elapsedMicroseconds / 1e6),
      loadedLatencyMs: loadedLatency,
    );
  }

  Future<_PhaseResult> _measureUploadWithLatency({
    required SpeedTestConfig config,
    required void Function(double mbps) onProgress,
    required bool Function() isCancelled,
  }) async {
    const parallelStreams = 3;
    final uploadBytes = config.uploadBytes;
    final bytesPerStream = uploadBytes ~/ parallelStreams;
    final stopwatch = Stopwatch()..start();
    var totalSent = 0;
    var successCount = 0;
    double? loadedLatency;

    final latencyFuture = () async {
      try {
        final s = await _measurePing(
          pingUrl: config.server.pingUrl,
          onSample: (_) {},
          isCancelled: isCancelled,
        );
        loadedLatency = s.avgMs;
      } on Object {
        // Latency measurement failed
      }
    }();

    final streamFutures = List.generate(parallelStreams, (index) async {
      try {
        final request = http.StreamedRequest('POST', Uri.parse(config.server.uploadUrl));
        request.headers['Content-Type'] = 'application/octet-stream';
        request.contentLength = bytesPerStream;
        final responseFuture = _client.send(request);
        
        var streamSent = 0;
        while (streamSent < bytesPerStream && !isCancelled()) {
          final size = min(128 * 1024, (bytesPerStream - streamSent).toInt());
          request.sink.add(List.filled(size, 0));
          streamSent += size;
          totalSent += size;
          successCount++;
          final elapsed = stopwatch.elapsedMicroseconds / 1e6;
          if (elapsed > 0) {
            onProgress(_bytesToMbps(totalSent, elapsed));
          }
          await Future.delayed(Duration.zero);
        }
        await request.sink.close();
        final resp = await responseFuture;
        await resp.stream.drain();
      } on Object catch (e) {
        debugPrint('Upload stream $index failed: $e');
      }
    });

    await Future.wait([...streamFutures, latencyFuture]);
    stopwatch.stop();

    if (totalSent == 0 && successCount == 0 && !isCancelled()) {
      throw const SpeedTestException('Upload failed. Please check your internet connection.');
    }

    return _PhaseResult(
      speedMbps: _bytesToMbps(totalSent, stopwatch.elapsedMicroseconds / 1e6),
      loadedLatencyMs: loadedLatency,
    );
  }

  double _bytesToMbps(int bytes, double seconds) {
    if (seconds <= 0) return 0;
    return (bytes * 8) / (seconds * 1000000);
  }

  void dispose() {
    _client.close();
    _ipInfo.dispose();
  }
}

class _PhaseResult {
  const _PhaseResult({required this.speedMbps, this.loadedLatencyMs});
  final double speedMbps;
  final double? loadedLatencyMs;
}

class SpeedTestException implements Exception {
  const SpeedTestException(this.message);
  final String message;
  @override
  String toString() => message;
}
