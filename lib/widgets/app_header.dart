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
            fontSize: 24,
            color: netChui.text,
            letterSpacing: -1,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Glass effect / Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    netChui.accent.withValues(alpha: isDark ? 0.15 : 0.08),
                    netChui.accent.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            // Decorative orbs
            Positioned(
              top: -50,
              right: -50,
              child: _HeaderOrb(
                color: netChui.accent.withValues(alpha: 0.1),
                size: 200,
              ),
            ),
            Positioned(
              bottom: -20,
              left: 100,
              child: _HeaderOrb(
                color: AppColors.blue.withValues(alpha: 0.05),
                size: 100,
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
