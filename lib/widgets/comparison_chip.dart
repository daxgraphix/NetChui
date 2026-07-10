import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/theme/app_theme.dart';

class ComparisonChip extends StatelessWidget {
  const ComparisonChip({super.key, required this.comparison, this.unit = 'Mbps'});

  final SpeedComparison? comparison;
  final String unit;

  @override
  Widget build(BuildContext context) {
    if (comparison == null) return const SizedBox.shrink();

    final s = AppState.instance.strings;
    final color = comparison!.improved ? AppColors.green : AppColors.red;
    final arrow = comparison!.improved ? '↑' : '↓';
    final value = comparison!.delta >= 10
        ? comparison!.delta.toStringAsFixed(0)
        : comparison!.delta.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            arrow,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$value $unit · ${s.vsLast}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }
}
