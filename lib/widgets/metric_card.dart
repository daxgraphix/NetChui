import 'package:flutter/material.dart';
import 'package:net_chui/theme/app_theme.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.accent,
    this.subtitle,
    this.isActive = false,
    this.semanticsLabel,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color accent;
  final String? subtitle;
  final bool isActive;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: semanticsLabel ?? '$label $value $unit',
      child: AnimatedScale(
        scale: isActive ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          decoration: BoxDecoration(
            color: isActive 
                ? (isDark ? accent.withValues(alpha: 0.15) : accent.withValues(alpha: 0.08))
                : colors.card.withValues(alpha: isDark ? 0.4 : 0.6),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isActive
                  ? accent.withValues(alpha: 0.5)
                  : colors.border.withValues(alpha: isDark ? 0.2 : 0.1),
              width: isActive ? 2.0 : 1.0,
            ),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: accent.withValues(alpha: 0.25),
                  blurRadius: 25,
                  spreadRadius: -5,
                  offset: const Offset(0, 8),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
              color: (isActive ? accent : colors.text).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isActive ? accent : colors.text).withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? accent : colors.text.withValues(alpha: 0.6),
              size: 22,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: colors.muted,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: colors.text,
                  letterSpacing: -1.5,
                  fontFamily: 'JetBrainsMono',
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: colors.muted,
                ),
              ),
            ],
          ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.muted.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
