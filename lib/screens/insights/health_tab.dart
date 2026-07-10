import 'package:flutter/material.dart';
import '../../services/health_analysis_service.dart';
import '../../theme/app_theme.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/widgets/glass_card.dart';
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
        _buildSectionTitle(context, s.keyMetrics),
        ...analysis.metrics.map((m) => _buildMetricCard(context, m)),
        const SizedBox(height: Spacing.xl),
        if (analysis.insights.isNotEmpty) ...[
          _buildSectionTitle(context, s.aiInsights),
          ...analysis.insights.map((i) => _buildInsightCard(context, i)),
        ],
        if (analysis.timeToFailure != null || analysis.optimalUsageTime != null) ...[
          const SizedBox(height: Spacing.xl),
          _buildSectionTitle(context, 'PREDICTIVE ANALYSIS'),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: context.netChui.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: context.netChui.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: context.netChui.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthHeader(BuildContext context) {
    final s = AppState.instance.strings;
    final score = analysis.overallScore;
    final color = score > 80 ? AppColors.green : (score > 50 ? Colors.orange : AppColors.red);

    return GlassCard(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${score.toInt()}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'JetBrainsMono'),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.networkIs(analysis.status),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  s.basedOnActivity7Days,
                  style: TextStyle(color: context.netChui.muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, HealthMetric metric) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.lg),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: metric.score > 0.8 ? AppColors.green : (metric.score > 0.5 ? Colors.orange : AppColors.red),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(metric.label.toUpperCase(), style: TextStyle(fontSize: 9, color: context.netChui.muted, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                const SizedBox(height: 4),
                Text(
                  metric.value, 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'JetBrainsMono'),
                ),
              ],
            ),
          ),
          if (metric.isImproving)
            const Icon(Icons.trending_up_rounded, color: AppColors.green, size: 20)
          else
            const Icon(Icons.trending_down_rounded, color: AppColors.red, size: 20),
        ],
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, String insight, {IconData? icon, Color? color}) {
    final finalIcon = icon ?? Icons.auto_awesome_rounded;
    final finalColor = color ?? AppColors.blue;
    
    return GlassCard(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.lg),
      color: finalColor,
      opacity: 0.05,
      borderColor: finalColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(finalIcon, color: finalColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              insight,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
