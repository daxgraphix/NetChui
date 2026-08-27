import 'package:flutter/material.dart';
import 'package:net_chui/theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.expandedHeight = 140,
    this.isPinned = true,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double expandedHeight;
  final bool isPinned;

  @override
  Widget build(BuildContext context) {
    final netChui = context.netChui;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: isPinned,
      stretch: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: leading,
      actions: [
        ...?actions,
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 32, // Further increased size
            color: netChui.text,
            letterSpacing: -1.5,
            height: 1.1,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Glass effect / Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    netChui.accent.withValues(alpha: isDark ? 0.2 : 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Decorative orbs
            Positioned(
              top: -60,
              right: -60,
              child: _HeaderOrb(
                color: netChui.accent.withValues(alpha: isDark ? 0.15 : 0.1),
                size: 240,
              ),
            ),
            Positioned(
              top: 20,
              left: -30,
              child: _HeaderOrb(
                color: AppColors.secondary.withValues(alpha: isDark ? 0.08 : 0.05),
                size: 140,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderOrb extends StatelessWidget {
  const _HeaderOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
