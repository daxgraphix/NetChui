import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/history_entry.dart';
import '../../theme/app_theme.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/widgets/glass_card.dart';

class PerformanceTab extends StatelessWidget {
  final bool isLoading;
  final List<HistoryEntry> speedHistory;
  final Widget emptyState;

  const PerformanceTab({
    super.key,
    required this.isLoading,
    required this.speedHistory,
    required this.emptyState,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (speedHistory.isEmpty) return emptyState;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceSummary(context),
          const SizedBox(height: Spacing.xl),
          _buildSectionTitle(context, s.downloadSpeedTrend),
          _buildSpeedChart(context, isDownload: true),
          const SizedBox(height: Spacing.xl),
          _buildSectionTitle(context, s.uploadSpeedTrend),
          _buildSpeedChart(context, isDownload: false),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: context.netChui.text.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildPerformanceSummary(BuildContext context) {
    final s = AppState.instance.strings;
    final downloads = speedHistory.map((e) => e.result.downloadMbps ?? 0.0).toList();
    final avgDown = downloads.isEmpty ? 0.0 : downloads.reduce((a, b) => a + b) / downloads.length;
    final maxDown = downloads.isEmpty ? 0.0 : downloads.reduce((a, b) => a > b ? a : b);

    return GlassCard(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: s.avgDownload, value: '${avgDown.toStringAsFixed(1)} Mbps'),
          _Stat(label: s.peakSpeed, value: '${maxDown.toStringAsFixed(1)} Mbps'),
        ],
      ),
    );
  }

  Widget _buildSpeedChart(BuildContext context, {required bool isDownload}) {
    final s = AppState.instance.strings;
    final data = speedHistory.reversed.toList();
    if (data.length < 2) {
      return GlassCard(
        height: 180,
        child: Center(
          child: Text(
            s.needMoreData,
            style: TextStyle(color: context.netChui.muted),
          ),
        ),
      );
    }

    final List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      final val = isDownload ? data[i].result.downloadMbps : data[i].result.uploadMbps;
      spots.add(FlSpot(i.toDouble(), val ?? 0.0));
    }

    final color = isDownload ? AppColors.red : AppColors.purple;

    return GlassCard(
      height: 200,
      padding: const EdgeInsets.fromLTRB(Spacing.xs, Spacing.xl, Spacing.xl, Spacing.sm),
      child: RepaintBoundary(
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (spot) => context.netChui.surface,
                tooltipBorder: BorderSide(color: context.netChui.border),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final date = data[spot.x.toInt()].timestamp;
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(1)} Mbps\n',
                      TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13),
                      children: [
                        TextSpan(
                          text: DateFormat('MMM d, HH:mm').format(date),
                          style: TextStyle(color: context.netChui.muted, fontWeight: FontWeight.w500, fontSize: 10),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (val, _) => Text(
                    val.toInt().toString(), 
                    style: TextStyle(fontSize: 10, color: context.netChui.muted, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: color,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: TextStyle(fontSize: 9, color: context.netChui.muted, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'JetBrainsMono')),
      ],
    );
  }
}
