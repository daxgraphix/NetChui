import 'package:flutter/material.dart';
import '../../services/health_analysis_service.dart';
import '../../theme/app_theme.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'package:net_chui/widgets/section_title.dart';
import '../../models/history_entry.dart';

class HealthTab extends StatelessWidget {
  final NetworkHealthAnalysis analysis;
  final List<HistoryEntry> speedHistory;
  final bool isInternal;

  const HealthTab({
    super.key,
    required this.analysis,
    required this.speedHistory,
    this.isInternal = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHealthHeader(context),
        const SizedBox(height: Spacing.xl),
        SectionTitle(s.keyMetrics),
        ...analysis.metrics.map((m) => _buildMetricCard(context, m)),
        const SizedBox(height: Spacing.xl),
        if (analysis.insights.isNotEmpty) ...[
          SectionTitle(s.aiInsights),
          ...analysis.insights.map((i) => _buildInsightCard(context, i)),
        ],
        if (analysis.timeToFailure != null || analysis.optimalUsageTime != null) ...[
          const SizedBox(height: Spacing.xl),
          SectionTitle('PREDICTIVE ANALYSIS'),
          if (analysis.timeToFailure != null)
            _buildInsightCard(context, analysis.timeToFailure!, icon: Icons.shutter_speed_rounded, color: AppColors.red),
          if (analysis.optimalUsageTime != null)
            _buildInsightCard(context, analysis.optimalUsageTime!, icon: Icons.schedule_rounded, color: AppColors.green),
        ],
      ],
    );

    if (isInternal) return body;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 120),
      child: body,
    );
  }

  Widget _buildHealthHeader(BuildContext context) {
    final s = AppState.instance.strings;
    final score = analysis.overallScore;
    final color = score > 80 ? AppColors.green : (score > 50 ? Colors.orange : AppColors.red);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return GlassCard(
      padding: EdgeInsets.all(isSmallScreen ? Spacing.lg : Spacing.xl),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: isSmallScreen ? 64 : 80,
                height: isSmallScreen ? 64 : 80,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: isSmallScreen ? 6 : 8,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${score.toInt()}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24, 
                  fontWeight: FontWeight.w900, 
                  fontFamily: 'JetBrainsMono'
                ),
              ),
            ],
          ),
          SizedBox(width: isSmallScreen ? 16 : 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  s.networkIs(analysis.status),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20, 
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.basedOnActivity7Days,
                  style: TextStyle(
                    color: context.netChui.muted, 
                    fontSize: isSmallScreen ? 12 : 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, HealthMetric metric) {
    final color = metric.score > 0.8 ? AppColors.green : (metric.score > 0.5 ? Colors.orange : AppColors.red);
    return GlassCard(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            metric.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: context.netChui.muted,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            metric.value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'JetBrainsMono',
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (metric.isImproving)
                      const Icon(Icons.trending_up_rounded, color: AppColors.green, size: 20)
                    else
                      const Icon(Icons.trending_down_rounded, color: AppColors.red, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, String insight, {IconData? icon, Color? color}) {
    final finalIcon = icon ?? Icons.auto_awesome_rounded;
    final finalColor = color ?? AppColors.blue;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: EdgeInsets.zero,
      color: finalColor,
      opacity: 0.05,
      borderColor: finalColor,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: finalColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(finalIcon, color: finalColor, size: 20),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        insight,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
