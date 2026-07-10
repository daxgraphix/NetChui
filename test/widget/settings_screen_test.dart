import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/l10n/app_localizations.dart';
import 'package:net_chui/screens/settings_screen.dart';
import 'package:net_chui/services/storage_service.dart';
import 'package:net_chui/theme/app_theme.dart';

void main() {
  setUpAll(() async {
    await StorageService.init();
    await AppState.initialize();
  });

  testWidgets('SettingsScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const SettingsScreen(),
        supportedLocales: const [Locale('en')],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });
}