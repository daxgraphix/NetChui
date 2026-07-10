class SpeedTestResult {
  const SpeedTestResult({
    this.pingMs,
    this.pingMinMs,
    this.pingMaxMs,
    this.jitterMs,
    this.downloadMbps,
    this.uploadMbps,
    this.publicIp,
    this.locationHint,
    this.isp,
    this.countryCode,
    this.downloadPingMs,
    this.uploadPingMs,
  });

  final double? pingMs;
  final double? pingMinMs;
  final double? pingMaxMs;
  final double? jitterMs;
  final double? downloadMbps;
  final double? uploadMbps;
  final String? publicIp;
  final String? locationHint;
  final String? isp;
  final String? countryCode;
  final double? downloadPingMs;
  final double? uploadPingMs;

  bool get hasData =>
      pingMs != null || downloadMbps != null || uploadMbps != null;

  SpeedTestResult copyWith({
    double? pingMs,
    double? pingMinMs,
    double? pingMaxMs,
    double? jitterMs,
    double? downloadMbps,
    double? uploadMbps,
    String? publicIp,
    String? locationHint,
    String? isp,
    String? countryCode,
    double? downloadPingMs,
    double? uploadPingMs,
  }) {
    return SpeedTestResult(
      pingMs: pingMs ?? this.pingMs,
      pingMinMs: pingMinMs ?? this.pingMinMs,
      pingMaxMs: pingMaxMs ?? this.pingMaxMs,
      jitterMs: jitterMs ?? this.jitterMs,
      downloadMbps: downloadMbps ?? this.downloadMbps,
      uploadMbps: uploadMbps ?? this.uploadMbps,
      publicIp: publicIp ?? this.publicIp,
      locationHint: locationHint ?? this.locationHint,
      isp: isp ?? this.isp,
      countryCode: countryCode ?? this.countryCode,
      downloadPingMs: downloadPingMs ?? this.downloadPingMs,
      uploadPingMs: uploadPingMs ?? this.uploadPingMs,
    );
  }

  String shareText() {
    final parts = <String>[];
    if (pingMs != null) {
      parts.add('Ping ${pingMs!.round()} ms');
      if (jitterMs != null) {
        parts.add('jitter ${jitterMs!.toStringAsFixed(1)} ms');
      }
    }
    if (downloadMbps != null) {
      parts.add('↓ ${_fmtMbps(downloadMbps!)} Mbps');
    }
    if (uploadMbps != null) {
      parts.add('↑ ${_fmtMbps(uploadMbps!)} Mbps');
    }
    return 'NetChui — ${parts.join(' · ')}';
  }

  static String _fmtMbps(double v) {
    if (v >= 100) return v.toStringAsFixed(0);
    if (v >= 10) return v.toStringAsFixed(1);
    return v.toStringAsFixed(2);
  }

  Map<String, dynamic> toJson() {
    return {
      'pingMs': pingMs,
      'pingMinMs': pingMinMs,
      'pingMaxMs': pingMaxMs,
      'jitterMs': jitterMs,
      'downloadMbps': downloadMbps,
      'uploadMbps': uploadMbps,
      'publicIp': publicIp,
      'locationHint': locationHint,
      'isp': isp,
      'countryCode': countryCode,
      'downloadPingMs': downloadPingMs,
      'uploadPingMs': uploadPingMs,
    };
  }

  factory SpeedTestResult.fromJson(Map<String, dynamic> json) {
    return SpeedTestResult(
      pingMs: (json['pingMs'] as num?)?.toDouble(),
      pingMinMs: (json['pingMinMs'] as num?)?.toDouble(),
      pingMaxMs: (json['pingMaxMs'] as num?)?.toDouble(),
      jitterMs: (json['jitterMs'] as num?)?.toDouble(),
      downloadMbps: (json['downloadMbps'] as num?)?.toDouble(),
      uploadMbps: (json['uploadMbps'] as num?)?.toDouble(),
      publicIp: json['publicIp'] as String?,
      locationHint: json['locationHint'] as String?,
      isp: json['isp'] as String?,
      countryCode: json['countryCode'] as String?,
      downloadPingMs: (json['downloadPingMs'] as num?)?.toDouble(),
      uploadPingMs: (json['uploadPingMs'] as num?)?.toDouble(),
    );
  }
}
