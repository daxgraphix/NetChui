import 'package:flutter/material.dart';
import 'package:net_chui/models/test_mode.dart';
import 'package:net_chui/theme/app_theme.dart';

class TestModeChips extends StatelessWidget {
  const TestModeChips({
    super.key,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
  });

  final TestMode selected;
  final ValueChanged<TestMode> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
      child: Row(
        children: TestMode.values.map((mode) {
          final isSelected = mode == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                mode.label(context, short: true).toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.8,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  color: isSelected ? Colors.white : colors.text.withValues(alpha: 0.5),
                ),
              ),
              selected: isSelected,
              onSelected: enabled ? (_) => onSelected(mode) : null,
              selectedColor: AppColors.red,
              backgroundColor: colors.card,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: isSelected ? AppColors.red : colors.border,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}