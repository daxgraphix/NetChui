import 'package:flutter/material.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'package:net_chui/theme/app_theme.dart';

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({
    super.key,
    required this.label,
    required this.isOnline,
    this.ip,
    this.location,
    this.isp,
    this.onTap,
    this.healthScore,
  });

  final String label;
  final bool isOnline;
  final String? ip;
  final String? location;
  final String? isp;
  final VoidCallback? onTap;
  final int? healthScore;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;
    final color = isOnline ? AppColors.red : colors.muted;

    return Semantics(
      label: 'Network status: ${isOnline ? 'Connected' : 'Disconnected'} to ${isp ?? label}. Health score: ${healthScore ?? 'N/A'}',
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          children: [
            _buildLeadingIndicator(context, isOnline, color, healthScore),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          (isp ?? label).toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: colors.text,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(isOnline: isOnline),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [ip, location].whereType<String>().join(' • '),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
            if (isOnline)
              Icon(Icons.chevron_right_rounded, color: colors.text.withValues(alpha: 0.4), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIndicator(BuildContext context, bool isOnline, Color color, int? healthScore) {
    final colors = context.netChui;
    if (!isOnline) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.wifi_off_rounded, color: color, size: 20),
      );
    }

    // Circular Health Indicator
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: (healthScore ?? 0) / 100,
            strokeWidth: 3,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              healthScore != null && healthScore < 50 ? AppColors.orange : color,
            ),
          ),
          Text(
            '${healthScore ?? 0}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOnline});
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final color = isOnline ? AppColors.green : AppColors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isOnline ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
