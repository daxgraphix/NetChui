import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/services/haptic_service.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/screens/scan_screen.dart';
import 'package:net_chui/screens/settings_screen.dart';
import 'package:net_chui/screens/speed_test_screen.dart';
import 'package:net_chui/screens/insights_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [
    SpeedTestScreen(),
    ScanScreen(),
    InsightsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 80,
        margin: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 20),
        decoration: BoxDecoration(
          color: context.netChui.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: context.netChui.text.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: NavigationBar(
            selectedIndex: _index,
            elevation: 0,
            height: 80,
            backgroundColor: Colors.transparent,
            indicatorColor: context.netChui.accent.withValues(alpha: 0.1),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            onDestinationSelected: (i) async {
              if (_index != i) {
                HapticService.selection();
                setState(() => _index = i);
              }
            },
            destinations: [
              _NavDest(
                icon: Icons.speed_rounded,
                selectedIcon: Icons.speed_rounded,
                label: s.test,
                isSelected: _index == 0,
              ),
              _NavDest(
                icon: Icons.radar_rounded,
                selectedIcon: Icons.radar_rounded,
                label: s.scan,
                isSelected: _index == 1,
              ),
              _NavDest(
                icon: Icons.auto_awesome_rounded,
                selectedIcon: Icons.auto_awesome_rounded,
                label: s.insights,
                isSelected: _index == 2,
              ),
              _NavDest(
                icon: Icons.settings_rounded,
                selectedIcon: Icons.settings_rounded,
                label: s.settings,
                isSelected: _index == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDest extends StatelessWidget {
  const _NavDest({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(icon, color: context.netChui.text.withValues(alpha: 0.4)),
      selectedIcon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.netChui.accent.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(selectedIcon, color: context.netChui.accent),
      ),
      label: label,
    );
  }
}

