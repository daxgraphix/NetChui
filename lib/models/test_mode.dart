import 'package:flutter/widgets.dart';
import 'package:net_chui/l10n/app_localizations.dart';

enum TestMode {
  full,
  pingOnly,
  downloadOnly,
  uploadOnly,
}

extension TestModeX on TestMode {
  String label(BuildContext context, {bool short = false}) {
    final s = AppLocalizations.of(context)!;
    return switch (this) {
      TestMode.full => short ? 'Full' : s.testModeFull,
      TestMode.pingOnly => short ? 'Ping' : s.testModePing,
      TestMode.downloadOnly => short ? 'Down' : s.testModeDownload,
      TestMode.uploadOnly => short ? 'Up' : s.testModeUpload,
    };
  }
}
