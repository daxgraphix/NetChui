import 'package:net_chui/models/speed_test_server.dart';
import 'package:net_chui/models/test_mode.dart';
import 'package:net_chui/models/test_size.dart';

class SpeedTestConfig {
  const SpeedTestConfig({
    required this.server,
    required this.size,
    required this.mode,
  });

  final SpeedTestServer server;
  final TestSize size;
  final TestMode mode;

  SpeedTestConfig copyWith({
    SpeedTestServer? server,
    TestSize? size,
    TestMode? mode,
  }) {
    return SpeedTestConfig(
      server: server ?? this.server,
      size: size ?? this.size,
      mode: mode ?? this.mode,
    );
  }

  int get downloadBytes => size.downloadBytes;
  int get uploadBytes => size.uploadBytes;
}
