import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:net_chui/l10n/app_localizations.dart';
import 'package:net_chui/models/app_settings.dart';
import 'package:net_chui/models/history_entry.dart';
import 'package:net_chui/models/speed_test_config.dart';
import 'package:net_chui/models/speed_test_result.dart';
import 'package:net_chui/models/speed_test_server.dart';
import 'package:net_chui/models/test_mode.dart';
import 'package:net_chui/models/network_log.dart';
import 'package:net_chui/services/connectivity_service.dart';
import 'package:net_chui/services/hardware_service.dart';
import 'package:net_chui/services/notification_service.dart';
import 'package:net_chui/services/storage_service.dart';
import 'package:fl_chart/fl_chart.dart';

class AppState extends ChangeNotifier {
  AppState._(this._storage, this._connectivity, this._hardware);

  static AppState get instance => _instance!;
  static final StorageService _storageInstance = StorageService.instance;
  static final ConnectivityService _connectivityInstance = ConnectivityService();
  static final HardwareService _hardwareInstance = HardwareService();
  static AppState? _instance;

  static Future<AppState> initialize() async {
    _instance = AppState._(_storageInstance, _connectivityInstance, _hardwareInstance);
    return _instance!;
  }

  final StorageService _storage;
  final ConnectivityService _connectivity;
  final HardwareService _hardware;

  AppSettings settings = const AppSettings();
  List<HistoryEntry> history = [];
  bool isOnline = true;
  String connectionLabel = '—';
  HardwareInfo hardwareInfo = HardwareInfo();
  List<FlSpot> signalHistory = [];
  double? lastDnsLatency;
  Timer? _scanTimer;
  StreamSubscription? _connectivitySub;

  Future<void> init() async {
    settings = _storage.loadSettings();
    history = await _storage.loadHistory();
    await _refreshConnectivity();
    await refreshHardwareInfo();
    
    _connectivitySub = _connectivity.onConnectivityChanged.listen((_) {
      _refreshConnectivity();
      refreshHardwareInfo();
    });

    if (settings.dailyReminderEnabled) {
      await _syncReminder();
    }

    _startSignalScanning();
  }

  Future<void> _startSignalScanning() async {
    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      double dbm;
      try {
        // Optimization: Fetch only dynamic info (RSSI, etc) during background scanning
        final info = await _hardware.getHardwareInfo(dynamicOnly: true);
        hardwareInfo = info;
        
        if (info.rssi != null) {
          dbm = info.rssi!.toDouble();
        } else {
          // Default/Placeholder if signal can't be read
          dbm = -60.0; 
        }
      } catch (e) {
        dbm = -100.0;
      }

      if (signalHistory.length >= 50) {
        signalHistory.removeAt(0);
      }
      signalHistory.add(FlSpot(timer.tick.toDouble(), dbm));

      // Save to database every 30 seconds for trend analysis
      if (timer.tick % 15 == 0) {
        await _storage.saveNetworkLog(NetworkLog()
          ..timestamp = DateTime.now()
          ..type = 'SIGNAL'
          ..category = 'CONNECTIVITY'
          ..severity = dbm < -80 ? 2 : (dbm < -70 ? 1 : 0)
          ..signalDbm = dbm
          ..title = 'Signal Stability'
          ..subtitle = connectionLabel);
      }
      
      notifyListeners();
    });
  }

  Future<void> refreshHardwareInfo() async {
    hardwareInfo = await _hardware.getHardwareInfo();
    notifyListeners();
  }

  AppLocalizations get strings {
    return lookupAppLocalizations(const Locale('en'));
  }

  Locale get locale => const Locale('en');

  SpeedTestConfig get speedTestConfig => SpeedTestConfig(
    server: SpeedTestServer.byId(settings.serverId),
    size: settings.testSize,
    mode: settings.testMode,
  );

  HistoryEntry? get lastHistoryEntry =>
      history.isNotEmpty ? history.first : null;

  int get networkHealthScore {
    if (!isOnline) return 0;

    double score = 100.0;

    // RSSI impact (Signal Strength)
    if (hardwareInfo.rssi != null) {
      int rssi = hardwareInfo.rssi!;
      if (rssi <= -90) {
        score -= 50;
      } else if (rssi <= -80) {
        score -= 30;
      } else if (rssi <= -70) {
        score -= 15;
      } else if (rssi <= -60) {
        score -= 5;
      }
    } else {
      score -= 10; // Slight penalty for unknown signal
    }

    // DNS Latency Impact (if available)
    if (lastDnsLatency != null) {
      if (lastDnsLatency! > 150) {
        score -= 20;
      } else if (lastDnsLatency! > 80) {
        score -= 10;
      } else if (lastDnsLatency! > 40) {
        score -= 5;
      }
    }

    // Recent Speed Test Impact (if within last 2 hours)
    final last = lastHistoryEntry;
    if (last != null &&
        last.timestamp.isAfter(DateTime.now().subtract(const Duration(hours: 2)))) {
      final dl = last.result.downloadMbps ?? 0;
      final ping = last.result.pingMs ?? 0;

      if (dl < 5) {
        score -= 30;
      } else if (dl < 20) {
        score -= 15;
      }

      if (ping > 150) {
        score -= 20;
      } else if (ping > 80) {
        score -= 10;
      }
    }

    return score.clamp(0, 100).toInt();
  }

  String get networkHealthLabel {
    final score = networkHealthScore;
    if (!isOnline) return 'OFFLINE';
    if (score >= 90) return 'EXCELLENT';
    if (score >= 70) return 'GOOD';
    if (score >= 40) return 'FAIR';
    return 'POOR';
  }

  List<double> get downloadTrend {
    return history
        .map((e) => e.result.downloadMbps)
        .whereType<double>()
        .take(7)
        .toList()
        .reversed
        .toList();
  }

  Future<void> _refreshConnectivity() async {
    isOnline = await _connectivity.isOnline;
    connectionLabel = await _connectivity.connectionLabel();
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    settings = settings.copyWith(onboardingDone: true);
    await _storage.saveSettings(settings);
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    settings = newSettings;
    await _storage.saveSettings(settings);
    await _refreshConnectivity();
    _connectivitySub?.cancel();
    _connectivitySub = _connectivity.onConnectivityChanged.listen((_) {
      _refreshConnectivity();
    });
    if (settings.dailyReminderEnabled) {
      await _syncReminder();
    } else {
      await NotificationService.instance.cancelDailyReminder();
    }
    notifyListeners();
  }

  Future<void> setTestMode(TestMode mode) async {
    await updateSettings(settings.copyWith(testMode: mode));
  }

  Future<void> addHistoryEntry({
    required SpeedTestResult result,
    required String connectionType,
  }) async {
    final entry = HistoryEntry.fromData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      result: result,
      connectionType: connectionType,
      serverId: settings.serverId,
      testMode: settings.testMode,
      testSizeName: settings.testSize.name,
    );
    
    await _storage.addHistoryEntry(entry);
    history = await _storage.loadHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    history = [];
    await _storage.clearHistory();
    notifyListeners();
  }

  Future<void> deleteHistoryEntry(String id) async {
    final index = history.indexWhere((e) => e.id == id);
    if (index != -1) {
      final entry = history[index];
      if (entry.isarId != null) {
        await _storage.deleteHistoryEntry(entry.isarId!);
      }
      history.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> deleteNetworkLog(int id) async {
    await _storage.deleteNetworkLog(id);
    notifyListeners();
  }

  Future<void> clearNetworkLogs() async {
    await _storage.clearNetworkLogs();
    notifyListeners();
  }

  Future<void> seedHistory(int count) async {
    final now = DateTime.now();
    final entries = List.generate(count, (i) {
      final timestamp = now.subtract(Duration(minutes: i * 30));
      return HistoryEntry.fromData(
        id: timestamp.millisecondsSinceEpoch.toString(),
        timestamp: timestamp,
        result: SpeedTestResult(
          pingMs: 20.0 + (i % 10),
          downloadMbps: 50.0 + (i % 50),
          uploadMbps: 20.0 + (i % 20),
          isp: 'Simulated ISP',
          publicIp: '1.2.3.4',
        ),
        connectionType: i % 2 == 0 ? 'WiFi' : 'Cellular',
        serverId: 'cloudflare',
        testMode: TestMode.full,
        testSizeName: 'standard',
      );
    });

    final stopwatch = Stopwatch()..start();
    await _storage.addHistoryEntries(entries);
    stopwatch.stop();
    debugPrint('Seeded $count entries in ${stopwatch.elapsedMilliseconds}ms');

    final loadStopwatch = Stopwatch()..start();
    history = await _storage.loadHistory();
    loadStopwatch.stop();
    debugPrint('Loaded ${history.length} entries in ${loadStopwatch.elapsedMilliseconds}ms');

    notifyListeners();
  }

  SpeedComparison? compareDownload(double? current) {
    return _compare(current, (r) => r.downloadMbps);
  }

  SpeedComparison? compareUpload(double? current) {
    return _compare(current, (r) => r.uploadMbps);
  }

  SpeedComparison? comparePing(double? current) {
    return _compare(current, (r) => r.pingMs, lowerIsBetter: true);
  }

  SpeedComparison? _compare(
    double? current,
    double? Function(SpeedTestResult r) pick, {
    bool lowerIsBetter = false,
  }) {
    if (current == null || history.length < 2) return null;
    final previous = history[1].result;
    final prevVal = pick(previous);
    if (prevVal == null) return null;
    final delta = current - prevVal;
    if (delta.abs() < 0.05) return null;
    final improved = lowerIsBetter ? delta < 0 : delta > 0;
    return SpeedComparison(delta: delta.abs(), improved: improved);
  }

  Future<void> _syncReminder() async {
    final s = strings;
    await NotificationService.instance.scheduleDailyReminder(
      hour: settings.reminderHour,
      minute: settings.reminderMinute,
      title: s.reminderTitle,
      body: s.reminderBody,
    );
  }

  Future<void> logRecommendation(String recommendation, SpeedTestResult? result) async {
    await _storage.saveNetworkLog(NetworkLog()
      ..timestamp = DateTime.now()
      ..type = 'RECOMMENDATION'
      ..category = 'PERFORMANCE'
      ..severity = 1
      ..recommendation = recommendation
      ..title = 'Network Optimization'
      ..subtitle = connectionLabel
      ..rawData = result != null ? jsonEncode(result.toJson()) : null);
  }

  Future<void> logToolResult(String toolType, String title, String subtitle, Map<String, dynamic> data, {String category = 'GENERAL', int severity = 0}) async {
    if (toolType == 'DNS_BENCHMARK') {
      final bestStr = subtitle.split('(').last.replaceAll('ms)', '');
      lastDnsLatency = double.tryParse(bestStr);
    }

    await _storage.saveNetworkLog(NetworkLog()
      ..timestamp = DateTime.now()
      ..type = toolType
      ..category = category
      ..severity = severity
      ..title = title
      ..subtitle = subtitle
      ..rawData = jsonEncode(data));
  }
  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }
}

class SpeedComparison {
  const SpeedComparison({required this.delta, required this.improved});

  final double delta;
  final bool improved;
}