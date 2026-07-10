import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:net_chui/theme/app_theme.dart';

class SignalChart extends StatelessWidget {
  const SignalChart({
    super.key,
    required this.spots,
    this.minY = -120,
    this.maxY = -30,
  });

  final List<FlSpot> spots;
  final double minY;
  final double maxY;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;

    if (spots.isEmpty) {
      return Center(
        child: Text(
          'Waiting for signal data...',
          style: TextStyle(color: colors.text.withValues(alpha: 0.3), fontSize: 12),
        ),
      );
    }

    return RepaintBoundary(
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => colors.surface.withValues(alpha: 0.95),
              tooltipRoundedRadius: 12,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tooltipBorder: BorderSide(color: colors.border),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                    '${touchedSpot.y.toInt()} dBm',
                    TextStyle(
                      color: colors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: colors.text.withValues(alpha: 0.04),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 30,
                getTitlesWidget: (value, meta) {
                  if (value == minY || value == maxY) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${value.toInt()}',
                      style: TextStyle(
                        color: colors.text.withValues(alpha: 0.3),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
                reservedSize: 32,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: spots.length > 50 ? spots[spots.length - 50].x : (spots.isNotEmpty ? spots.first.x : 0),
          maxX: spots.isNotEmpty ? spots.last.x : 0,
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.4,
              preventCurveOverShooting: true,
              gradient: LinearGradient(
                colors: [
                  context.netChui.accent,
                  context.netChui.accent.withValues(alpha: 0.8),
                ],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) => spot.x == barData.spots.last.x,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: context.netChui.accent,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    context.netChui.accent.withValues(alpha: 0.2),
                    context.netChui.accent.withValues(alpha: 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              shadow: Shadow(
                color: context.netChui.accent.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutQuad,
      ),
    );
  }
}
