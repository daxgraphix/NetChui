import 'dart:math';
import 'dart:convert';
import '../services/storage_service.dart';
import '../app/app_state.dart';
import '../services/network_analysis_service.dart';

class NetworkHealthAnalysis {
  final double overallScore;
  final String status;
  final List<HealthMetric> metrics;
  final List<String> insights;
  final String? timeToFailure;
  final String? optimalUsageTime;

  NetworkHealthAnalysis({
    required this.overallScore,
    required this.status,
    required this.metrics,
    required this.insights,
    this.timeToFailure,
    this.optimalUsageTime,
  });
}

class HealthMetric {
  final String label;
  final String value;
  final double score; // 0.0 to 1.0
  final bool isImproving;

  HealthMetric({
    required this.label,
    required this.value,
    required this.score,
    this.isImproving = true,
  });
}

class HealthAnalysisService {
  final StorageService _storage = StorageService.instance;

  Future<NetworkHealthAnalysis> analyzeRecentHealth() async {
    final s = AppState.instance.strings;
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final logs = await _storage.loadNetworkLogs(start: weekAgo);
    final history = await _storage.loadHistory();
    final recentHistory = history.where((e) => e.timestamp.isAfter(weekAgo)).toList();

    final metrics = <HealthMetric>[];
    final insights = <String>[];
    double totalScore = 0;
    int metricCount = 0;

    // 1. Signal Stability
    final signals = logs.where((l) => l.type == 'SIGNAL').toList();
    if (signals.isNotEmpty) {
      final avgDbm = signals.map((e) => e.signalDbm ?? -100.0).reduce((a, b) => a + b) / signals.length;
      final variance = _calculateVariance(signals.map((e) => e.signalDbm ?? -100.0).toList());
      
      // score: -30dBm is 1.0, -100dBm is 0.0. Linear scale for simplicity
      final signalScore = ((avgDbm + 100) / 70).clamp(0.0, 1.0);
      final stabilityScore = (1.0 - (variance / 100)).clamp(0.0, 1.0);
      
      final combinedSignal = (signalScore * 0.6) + (stabilityScore * 0.4);
      metrics.add(HealthMetric(
        label: s.healthMetricSignalStability,
        value: avgDbm > -60 ? s.statusExcellent : (avgDbm > -80 ? s.stable : s.weak),
        score: combinedSignal,
      ));
      totalScore += combinedSignal;
      metricCount++;

      if (avgDbm < -85) {
        insights.add(s.insightLowSignal);
      }
      if (variance > 20) {
        insights.add(s.insightHighFluctuations);
      }
    }

    // 2. Speed Performance
    if (recentHistory.length >= 2) {
      final current = recentHistory.first.result.downloadMbps ?? 0;
      final previous = recentHistory.skip(1).first.result.downloadMbps ?? 0;
      final avg = recentHistory.map((e) => e.result.downloadMbps ?? 0).reduce((a, b) => a + b) / recentHistory.length;
      
      // Arbitrary score based on 100Mbps being "perfect" for mobile/typical use
      final speedScore = (avg / 100).clamp(0.0, 1.0);
      
      metrics.add(HealthMetric(
        label: s.healthMetricDownloadSpeed,
        value: '${avg.toStringAsFixed(1)} Mbps',
        score: speedScore,
        isImproving: current >= previous,
      ));
      totalScore += speedScore;
      metricCount++;

      if (avg < 15) {
        insights.add(s.insightSlowSpeed);
      }
    }

    // 3. DNS & Latency
    final dnsLogs = logs.where((l) => l.type == 'DNS_BENCHMARK').toList();
    if (dnsLogs.isNotEmpty) {
      double avgLatency = 0;
      int count = 0;
      for (var log in dnsLogs) {
         if (log.rawData != null) {
           try {
             final data = json.decode(log.rawData!);
             final best = data['best_ms'] as num?;
             if (best != null) {
               avgLatency += best.toDouble();
               count++;
             }
           } catch (_) {}
         }
      }
      
      if (count > 0) {
        avgLatency /= count;
        final dnsScore = (1.0 - (avgLatency / 200)).clamp(0.0, 1.0);
        
        metrics.add(HealthMetric(
          label: s.healthMetricDnsLatency,
          value: '${avgLatency.toInt()} ms',
          score: dnsScore,
        ));
        totalScore += dnsScore;
        metricCount++;
        
        if (avgLatency > 100) {
          insights.add(s.insightSlowDns);
        }
      }
    }

    // 4. Security Audit
    final securityLogs = logs.where((l) => l.category == 'SECURITY').toList();
    if (securityLogs.isNotEmpty) {
      int highCount = securityLogs.where((l) => l.severity >= 2).length;
      int totalSecurity = securityLogs.length;
      
      final securityScore = (1.0 - (highCount / totalSecurity)).clamp(0.0, 1.0);
      
      metrics.add(HealthMetric(
        label: s.healthMetricSecurityAudit,
        value: highCount == 0 ? s.healthValueSecure : s.healthValueWarnings(highCount),
        score: securityScore,
      ));
      totalScore += securityScore;
      metricCount++;

      if (highCount > 0) {
        insights.add(s.insightSecurityVulnerability(highCount));
      }
    }

    // 5. Port Exposure (New)
    final portScanLogs = logs.where((l) => l.type == 'LAN_PORT_SCAN').toList();
    if (portScanLogs.isNotEmpty) {
      int exposedDevices = 0;
      for (var log in portScanLogs) {
        try {
          final data = json.decode(log.rawData!);
          final results = data['results'] as List?;
          if (results != null && results.any((r) => r['status'] == 'Open')) {
            exposedDevices++;
          }
        } catch (_) {}
      }
      
      if (exposedDevices > 0) {
        insights.add('Security Warning: $exposedDevices devices on your network have open ports exposed.');
      }
    }

    // 6. Channel Optimization (New)
    try {
      final recommendation = await NetworkAnalysisService().getOptimizationRecommendation();
      if (recommendation != null) {
        insights.add(s.switchChannelRecommendation(
          recommendation['recommendedChannel'].toString(),
          recommendation['band'].toString(),
        ));
      }
    } catch (_) {}

    // 7. Predictive Insights (New)
    String? timeToFailure;
    String? optimalUsageTime;

    if (recentHistory.isNotEmpty) {
      final eveningTests = recentHistory.where((e) => e.timestamp.hour >= 18 && e.timestamp.hour <= 22).toList();
      final morningTests = recentHistory.where((e) => e.timestamp.hour >= 6 && e.timestamp.hour <= 10).toList();
      
      if (eveningTests.isNotEmpty && morningTests.isNotEmpty) {
        final avgEvening = eveningTests.map((e) => e.result.downloadMbps ?? 0).reduce((a, b) => a + b) / eveningTests.length;
        final avgMorning = morningTests.map((e) => e.result.downloadMbps ?? 0).reduce((a, b) => a + b) / morningTests.length;
        
        if (avgMorning > avgEvening * 1.5) {
          optimalUsageTime = 'Your network is 50% faster in the mornings (6 AM - 10 AM).';
        } else {
          optimalUsageTime = 'Network performance remains consistent throughout the day.';
        }
      }

      // Simple trend-based "Time to Failure"
      if (recentHistory.length >= 3) {
        final lastThree = recentHistory.take(3).map((e) => e.result.downloadMbps ?? 0).toList();
        if (lastThree[0] < lastThree[1] && lastThree[1] < lastThree[2]) {
          // Degrading performance
          timeToFailure = 'Warning: Performance trend is declining. Expected degradation in 2-3 days if trend continues.';
        }
      }
    }

    final finalScore = metricCount > 0 ? (totalScore / metricCount) * 100 : 0.0;
    
    return NetworkHealthAnalysis(
      overallScore: finalScore,
      status: finalScore > 80 ? s.healthStatusHealthy : (finalScore > 50 ? s.healthStatusFair : s.healthStatusPoor),
      metrics: metrics,
      insights: insights,
      timeToFailure: timeToFailure,
      optimalUsageTime: optimalUsageTime,
    );
  }

  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0;
    final avg = values.reduce((a, b) => a + b) / values.length;
    final sumSquaredDiff = values.map((v) => pow(v - avg, 2)).reduce((a, b) => a + b);
    return sumSquaredDiff / values.length;
  }
}
