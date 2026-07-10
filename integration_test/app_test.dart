import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:net_chui/l10n/app_localizations.dart';
import 'package:net_chui/screens/main_shell.dart';
import 'package:net_chui/screens/onboarding_screen.dart';
import 'package:net_chui/screens/splash_screen.dart';
import 'package:net_chui/theme/app_theme.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('splash navigates after delay', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const SplashScreen(),
        supportedLocales: const [Locale('en')],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));

    final hasOnboarding = find.byType(OnboardingScreen);
    final hasMainShell = find.byType(MainShell);

    expect(
      (hasOnboarding.evaluate().isNotEmpty) || (hasMainShell.evaluate().isNotEmpty),
      true,
      reason: 'Should navigate to onboarding or main shell after splash',
    );
  });
}