import 'dart:math';

class PingStats {
  const PingStats({
    required this.avgMs,
    required this.minMs,
    required this.maxMs,
    required this.jitterMs,
    required this.samples,
  });

  final double avgMs;
  final double minMs;
  final double maxMs;
  final double jitterMs;
  final int samples;

  factory PingStats.fromSamples(List<double> samples) {
    if (samples.isEmpty) {
      return const PingStats(
        avgMs: 0,
        minMs: 0,
        maxMs: 0,
        jitterMs: 0,
        samples: 0,
      );
    }
    final avg = samples.reduce((a, b) => a + b) / samples.length;
    final minVal = samples.reduce((a, b) => a < b ? a : b);
    final maxVal = samples.reduce((a, b) => a > b ? a : b);
    final variance = samples
            .map((s) => (s - avg) * (s - avg))
            .reduce((a, b) => a + b) /
        samples.length;
    return PingStats(
      avgMs: avg,
      minMs: minVal,
      maxMs: maxVal,
      jitterMs: sqrt(variance),
      samples: samples.length,
    );
  }
}
