import 'dart:math' as math;
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
    final color = isOnline ? colors.accent : colors.muted;

    return Semantics(
      label: 'Network status: ${isOnline ? 'Connected' : 'Disconnected'} to ${isp ?? label}. Health score: ${healthScore ?? 'N/A'}',
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(isOnline: isOnline),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    [ip, location].whereType<String>().join(' • '),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.muted,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            if (isOnline)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.border.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_right_rounded, color: colors.muted, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIndicator(BuildContext context, bool isOnline, Color color, int? healthScore) {
    final colors = context.netChui;

    if (!isOnline) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
        ),
        child: Icon(Icons.wifi_off_rounded, color: color, size: 22),
      );
    }

    // Circular Health Indicator
    final score = healthScore ?? 0;
    final scoreColor = score > 80 ? colors.success : (score > 50 ? colors.info : colors.warning);

    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                startAngle: 0,
                endAngle: math.pi * 2,
                stops: const [0, 0.9],
                center: Alignment.center,
                colors: [scoreColor, scoreColor.withValues(alpha: 0.1)],
              ).createShader(rect);
            },
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 4,
              strokeCap: StrokeCap.round,
              backgroundColor: colors.border.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            ),
          ),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              fontFamily: 'JetBrainsMono',
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
    final colors = context.netChui;
    final color = isOnline ? colors.success : colors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Text(
        isOnline ? 'ONLINE' : 'OFFLINE',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
