import 'package:flutter/material.dart';
import 'package:net_chui/theme/app_theme.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background layer with RepaintBoundary to avoid unnecessary repaints of gradients
        RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              Positioned(
                top: -150,
                right: -100,
                child: _orb(context.netChui.accent.withValues(alpha: isDark ? 0.12 : 0.08), 500),
              ),
              Positioned(
                top: 300,
                left: -150,
                child: _orb(AppColors.blue.withValues(alpha: isDark ? 0.08 : 0.05), 400),
              ),
              Positioned(
                bottom: -100,
                right: -150,
                child: _orb(AppColors.purple.withValues(alpha: isDark ? 0.1 : 0.06), 450),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }

  Widget _orb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}