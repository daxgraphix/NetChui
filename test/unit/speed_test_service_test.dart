import 'package:flutter_test/flutter_test.dart';
import 'package:net_chui/models/speed_test_phase.dart';
import 'package:net_chui/models/speed_test_result.dart';
import 'package:net_chui/services/speed_test_service.dart';

void main() {
  group('SpeedTestService', () {
    test('initial phase is idle', () {
      final service = SpeedTestService();
      expect(service, isNotNull);
    });

    test('SpeedTestResult defaults are null', () {
      final result = const SpeedTestResult();
      expect(result.pingMs, isNull);
      expect(result.downloadMbps, isNull);
      expect(result.uploadMbps, isNull);
    });

    test('SpeedTestResult copyWith preserves unchanged fields', () {
      final result = const SpeedTestResult(
        pingMs: 10.0,
        downloadMbps: 50.0,
      );
      final updated = result.copyWith(uploadMbps: 20.0);
      expect(updated.pingMs, 10.0);
      expect(updated.downloadMbps, 50.0);
      expect(updated.uploadMbps, 20.0);
    });

    test('SpeedTestResult shareText contains expected parts', () {
      final result = const SpeedTestResult(
        pingMs: 25.0,
        downloadMbps: 100.0,
        uploadMbps: 20.0,
      );
      final text = result.shareText();
      expect(text, contains('NetChui'));
      expect(text, contains('Ping 25 ms'));
      expect(text, contains('↓ 100 Mbps'));
      expect(text, contains('↑ 20.0 Mbps'));
    });
  });

  group('SpeedTestPhase', () {
    test('phases have correct ordering', () {
      expect(SpeedTestPhase.idle.index, lessThan(SpeedTestPhase.ping.index));
      expect(SpeedTestPhase.ping.index, lessThan(SpeedTestPhase.download.index));
      expect(SpeedTestPhase.download.index, lessThan(SpeedTestPhase.upload.index));
      expect(SpeedTestPhase.upload.index, lessThan(SpeedTestPhase.done.index));
    });
  });
}