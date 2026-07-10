import 'package:flutter/material.dart';
import '../app/app_state.dart';
import '../theme/app_theme.dart';

class OfflineOverlay extends StatelessWidget {
  const OfflineOverlay({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_off_rounded, color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.offline,
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.accent, fontSize: 15),
                    ),
                    Text(
                      s.offlineHint,
                      style: TextStyle(fontSize: 12, color: context.netChui.text.withValues(alpha: 0.7), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(s.retry, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.accent, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
