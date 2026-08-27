import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/network_log.dart';
import '../../theme/app_theme.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'package:net_chui/widgets/section_title.dart';

class SignalTrendTab extends StatelessWidget {
  final bool isLoading;
  final List<NetworkLog> signalHistory;
  final Widget emptyState;

  const SignalTrendTab({
    super.key,
    required this.isLoading,
    required this.signalHistory,
    required this.emptyState,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (signalHistory.isEmpty) return emptyState;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(context),
          const SizedBox(height: Spacing.xl),
          SectionTitle(s.weeklyStability),
          _buildTrendChart(context),
          const SizedBox(height: Spacing.xl),
          SectionTitle('RECENT SIGNAL READINGS'),
          _buildSignalList(context),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final s = AppState.instance.strings;
    final avg = signalHistory.map((e) => e.signalDbm ?? -100).reduce((a, b) => a + b) / signalHistory.length;
    final min = signalHistory.map((e) => e.signalDbm ?? -100).reduce((a, b) => a < b ? a : b);
    final max = signalHistory.map((e) => e.signalDbm ?? -100).reduce((a, b) => a > b ? a : b);

    return GlassCard(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: s.average, value: '${avg.toInt()} dBm', color: context.netChui.info),
          _Stat(label: s.lowest, value: '${min.toInt()} dBm', color: context.netChui.accent),
          _Stat(label: s.highest, value: '${max.toInt()} dBm', color: AppColors.green),
        ],
      ),
    );
  }

  Widget _buildTrendChart(BuildContext context) {
    final s = AppState.instance.strings;
    if (signalHistory.length < 2) {
      return GlassCard(
        height: 240,
        child: Center(
          child: Text(
            s.collectingMoreData,
            style: TextStyle(color: context.netChui.muted),
          ),
        ),
      );
    }

    final List<FlSpot> spots = [];
    for (int i = 0; i < signalHistory.length; i++) {
      spots.add(FlSpot(i.toDouble(), signalHistory[i].signalDbm ?? -100));
    }

    return GlassCard(
      height: 240,
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
                    final log = signalHistory[spot.x.toInt()];
                    return LineTooltipItem(
                      '${spot.y.toInt()} dBm\n',
                      TextStyle(color: context.netChui.accent, fontWeight: FontWeight.w900, fontSize: 13),
                      children: [
                        TextSpan(
                          text: DateFormat('HH:mm').format(log.timestamp),
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
                color: context.netChui.accent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [context.netChui.accent.withValues(alpha: 0.2), context.netChui.accent.withValues(alpha: 0)],
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

  Widget _buildSignalList(BuildContext context) {
    final count = signalHistory.length > 20 ? 20 : signalHistory.length;
    return GlassCard(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: context.netChui.accent,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: count,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: context.netChui.border.withValues(alpha: 0.1),
                  indent: 48,
                ),
                itemBuilder: (context, i) {
                  final log = signalHistory[signalHistory.length - 1 - i];
                  final dbm = log.signalDbm?.toInt() ?? -100;
                  return ListTile(
                    dense: true,
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _getSignalColor(context, dbm).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.circle, color: _getSignalColor(context, dbm), size: 10),
                    ),
                    title: Text(
                      '$dbm dBm',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'JetBrainsMono',
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      log.subtitle ?? 'Unknown Network',
                      style: TextStyle(fontSize: 12, color: context.netChui.muted, fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(
                      DateFormat('HH:mm').format(log.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: context.netChui.subtle,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSignalColor(BuildContext context, int rssi) {
    if (rssi > -60) return AppColors.green;
    if (rssi > -75) return Colors.orange;
    return context.netChui.accent;
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: context.netChui.muted,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontFamily: 'JetBrainsMono',
            color: color ?? context.netChui.text,
            letterSpacing: -1.0,
          ),
        ),
      ],
    );
  }
}
