import 'package:flutter/widgets.dart';
import 'package:net_chui/l10n/app_localizations.dart';

enum TestSize {
  quick,
  standard,
  accurate,
}

extension TestSizeX on TestSize {
  int get downloadBytes => switch (this) {
        TestSize.quick => 2 * 1024 * 1024,
        TestSize.standard => 8 * 1024 * 1024,
        TestSize.accurate => 20 * 1024 * 1024,
      };

  int get uploadBytes => switch (this) {
        TestSize.quick => 1 * 1024 * 1024,
        TestSize.standard => 4 * 1024 * 1024,
        TestSize.accurate => 10 * 1024 * 1024,
      };

  String label(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return switch (this) {
      TestSize.quick => s.testSizeQuick,
      TestSize.standard => s.testSizeStandard,
      TestSize.accurate => s.testSizeAccurate,
    };
  }
}
