import 'package:flutter/material.dart';
import 'package:net_chui/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 64,
    this.showBackground = true,
  });

  final double size;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final logo = Container(
      width: size * 0.8,
      height: size * 0.8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.netChui.accent.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/tiger.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.speed_rounded,
            size: size * 0.5,
            color: context.netChui.accent,
          ),
        ),
      ),
    );

    if (!showBackground) return logo;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.netChui.card,
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.8),
            isDark ? Colors.white.withValues(alpha: 0.01) : Colors.white.withValues(alpha: 0.2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.netChui.accent.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: size * 0.5,
            spreadRadius: 2,
            offset: Offset(0, size * 0.1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: context.netChui.border.withValues(alpha: isDark ? 0.2 : 0.1),
          width: 1,
        ),
      ),
      child: Center(child: logo),
    );
  }
}
