import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/l10n/app_localizations.dart';
import 'package:net_chui/screens/splash_screen.dart';
import 'package:net_chui/services/notification_service.dart';
import 'package:net_chui/services/storage_service.dart';
import 'package:net_chui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.instance.init();
  final state = await AppState.initialize();
  await state.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const NetChuiApp());
}

class NetChuiApp extends StatelessWidget {
  const NetChuiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final isDark = state.settings.themeMode == ThemeMode.dark ||
            (state.settings.themeMode == ThemeMode.system &&
                WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.dark);

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor:
                isDark ? AppColors.black : AppColors.white,
          ),
        );

        return MaterialApp(
          title: 'NetChui',
          debugShowCheckedModeBanner: false,
          themeMode: state.settings.themeMode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          locale: state.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) {
            return child ?? const SizedBox.shrink();
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
