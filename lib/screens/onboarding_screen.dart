import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/screens/main_shell.dart';
import 'package:net_chui/widgets/app_logo.dart';
import 'package:net_chui/services/haptic_service.dart';
import 'package:net_chui/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await AppState.instance.completeOnboarding();
    if (!mounted) return;
    await HapticService.light();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: context.netChui.background,
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.netChui.accent.withValues(alpha: 0.05),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo/Name in corner
                      Row(
                        children: [
                          const AppLogo(size: 24, showBackground: false),
                          const SizedBox(width: 8),
                          Text(
                            s.appName,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () async {
                          HapticService.selection();
                          _finish();
                        },
                        style: TextButton.styleFrom(foregroundColor: context.netChui.muted),
                        child: Text(s.skip),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3,
                    onPageChanged: (i) {
                      if (_page != i) HapticService.selection();
                      setState(() => _page = i);
                    },
                    itemBuilder: (_, index) {
                      final icons = [
                        Icons.speed_rounded,
                        Icons.wifi_tethering_rounded,
                        Icons.security_rounded,
                      ];
                      final colors = [
                        context.netChui.accent,
                        AppColors.blue,
                        AppColors.green,
                      ];
                      
                      return Padding(
                        padding: const EdgeInsets.all(Spacing.xxl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: colors[index].withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: colors[index].withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colors[index].withValues(alpha: 0.3), width: 2),
                                  ),
                                  child: Icon(icons[index], size: 56, color: colors[index]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),
                            Text(
                              switch (index) {
                                0 => s.onboardingTitle1,
                                1 => s.onboardingTitle2,
                                2 => s.onboardingTitle3,
                                _ => '',
                              },
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                switch (index) {
                                  0 => s.onboardingBody1,
                                  1 => s.onboardingBody2,
                                  2 => s.onboardingBody3,
                                  _ => '',
                                },
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: context.netChui.muted,
                                  height: 1.6,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _page == i ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _page == i ? context.netChui.accent : context.netChui.border,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: FilledButton(
                          onPressed: () async {
                            if (_page < 2) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                              );
                            } else {
                              _finish();
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: context.netChui.text,
                            foregroundColor: context.netChui.background,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            _page < 2 ? s.next : s.getStarted,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
