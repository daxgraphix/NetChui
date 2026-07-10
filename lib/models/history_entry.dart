import 'package:isar/isar.dart';
import 'package:net_chui/models/speed_test_result.dart';
import 'package:net_chui/models/test_mode.dart';

part 'history_entry.g.dart';

@collection
class HistoryEntry {
  Id? isarId;

  late String id;
  late DateTime timestamp;
  late String connectionType;
  late String serverId;
  
  @enumerated
  late TestMode testMode;
  
  late String testSizeName;

  // SpeedTestResult fields embedded
  double? pingMs;
  double? pingMinMs;
  double? pingMaxMs;
  double? jitterMs;
  double? downloadMbps;
  double? uploadMbps;
  String? publicIp;
  String? locationHint;
  String? isp;
  String? countryCode;
  double? downloadPingMs;
  double? uploadPingMs;

  HistoryEntry();

  HistoryEntry.fromData({
    required this.id,
    required this.timestamp,
    required SpeedTestResult result,
    required this.connectionType,
    required this.serverId,
    required this.testMode,
    required this.testSizeName,
  }) {
    pingMs = result.pingMs;
    pingMinMs = result.pingMinMs;
    pingMaxMs = result.pingMaxMs;
    jitterMs = result.jitterMs;
    downloadMbps = result.downloadMbps;
    uploadMbps = result.uploadMbps;
    publicIp = result.publicIp;
    locationHint = result.locationHint;
    isp = result.isp;
    countryCode = result.countryCode;
    downloadPingMs = result.downloadPingMs;
    uploadPingMs = result.uploadPingMs;
  }

  @ignore
  SpeedTestResult get result => SpeedTestResult(
        pingMs: pingMs,
        pingMinMs: pingMinMs,
        pingMaxMs: pingMaxMs,
        jitterMs: jitterMs,
        downloadMbps: downloadMbps,
        uploadMbps: uploadMbps,
        publicIp: publicIp,
        locationHint: locationHint,
        isp: isp,
        countryCode: countryCode,
        downloadPingMs: downloadPingMs,
        uploadPingMs: uploadPingMs,
      );
}
