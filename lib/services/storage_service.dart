import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:net_chui/models/app_settings.dart';
import 'package:net_chui/models/history_entry.dart';
import 'package:net_chui/models/network_log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();
  static StorageService? _instance;
  static StorageService get instance => _instance!;

  static const _settingsKey = 'app_settings_secure';
  static const _settingsKeyPlain = 'app_settings';

  late final FlutterSecureStorage _secure;
  SharedPreferences? _prefs;
  Isar? _isar;

  static Future<StorageService> init() async {
    _instance = StorageService._();
    _instance!._secure = const FlutterSecureStorage();
    try {
      _instance!._prefs = await SharedPreferences.getInstance();
      
      final dir = await getApplicationDocumentsDirectory();
      _instance!._isar = await Isar.open(
        [HistoryEntrySchema, NetworkLogSchema],
        directory: dir.path,
      );
    } on Object {
      _instance!._prefs = null;
    }
    return _instance!;
  }

  bool get isAvailable => _prefs != null;

  AppSettings loadSettings() {
    final raw = _prefs?.getString(_settingsKey) ?? _prefs?.getString(_settingsKeyPlain);
    if (raw == null) return const AppSettings();
    return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveSettings(AppSettings settings) async {
    final encoded = jsonEncode(settings.toJson());
    try {
      await _secure.write(key: _settingsKey, value: encoded);
    } catch (e) {
      await _plainWrite(_settingsKeyPlain, encoded);
    }
    // Update plain prefs too, but avoid storing sensitive things there if possible.
    await _plainWrite(_settingsKey, encoded);
  }

  Future<List<HistoryEntry>> loadHistory() async {
    if (_isar == null) return [];
    return await _isar!.historyEntrys.where().sortByTimestampDesc().findAll();
  }

  Future<void> addHistoryEntry(HistoryEntry entry) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.historyEntrys.put(entry);
    });
  }

  Future<void> addHistoryEntries(List<HistoryEntry> entries) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.historyEntrys.putAll(entries);
    });
  }

  Future<void> deleteNetworkLog(int id) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.networkLogs.delete(id);
    });
  }

  Future<void> deleteHistoryEntry(Id id) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.historyEntrys.delete(id);
    });
  }

  Future<void> clearHistory() async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.historyEntrys.clear();
    });
  }


  // --- Network Logs ---
  Future<void> saveNetworkLog(NetworkLog log) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.networkLogs.put(log);
    });
  }

  Future<List<NetworkLog>> loadNetworkLogs({
    String? type,
    String? category,
    int? minSeverity,
    DateTime? start,
    DateTime? end,
  }) async {
    if (_isar == null) return [];

    var filter = _isar!.networkLogs.filter();

    QueryBuilder<NetworkLog, NetworkLog, QAfterFilterCondition> q;

    if (type != null) {
      q = filter.typeEqualTo(type);
    } else {
      q = filter.timestampGreaterThan(DateTime(2000));
    }

    if (category != null) {
      q = q.and().categoryEqualTo(category);
    }
    if (minSeverity != null) {
      q = q.and().severityGreaterThan(minSeverity - 1);
    }
    if (start != null) {
      q = q.and().timestampGreaterThan(start);
    }
    if (end != null) {
      q = q.and().timestampLessThan(end);
    }

    return await q.sortByTimestampDesc().findAll();
  }

  Future<List<NetworkLog>> getSignalHistory(DateTime start) async {
    if (_isar == null) return [];
    return await _isar!.networkLogs
        .filter()
        .typeEqualTo('SIGNAL')
        .timestampGreaterThan(start)
        .sortByTimestamp()
        .findAll();
  }

  Future<void> clearNetworkLogs() async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.networkLogs.clear();
    });
  }

  Future<void> pruneLogs({int daysToKeep = 30}) async {
    if (_isar == null) return;
    final cutoff = DateTime.now().subtract(Duration(days: daysToKeep));
    await _isar!.writeTxn(() async {
      await _isar!.networkLogs.filter().timestampLessThan(cutoff).deleteAll();
    });
  }

  Future<void> _plainWrite(String key, String value) async {
    if (_prefs == null) return;
    try {
      await _prefs!.setString(key, value);
    } on Object {
      // ignore
    }
  }
}
