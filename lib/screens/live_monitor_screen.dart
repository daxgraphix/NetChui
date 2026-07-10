import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/network_analysis_service.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import '../theme/app_theme.dart';
import '../app/app_state.dart';

class LiveMonitorScreen extends StatefulWidget {
  const LiveMonitorScreen({super.key});

  @override
  State<LiveMonitorScreen> createState() => _LiveMonitorScreenState();
}

class _LiveMonitorScreenState extends State<LiveMonitorScreen> {
  final _service = NetworkAnalysisService();
  StreamSubscription<LiveNetworkStats>? _subscription;
  LiveNetworkStats? _currentStats;
  final List<FlSpot> _pingSpots = [];
  double _timer = 0;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _subscription = _service.streamLiveNetworkStats().listen((stats) {
      if (mounted) {
        setState(() {
          _currentStats = stats;
          _timer += 1;
          if (stats.pingMs > 0) {
            _pingSpots.add(FlSpot(_timer, stats.pingMs));
            if (_pingSpots.length > 50) _pingSpots.removeAt(0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.netChui;
    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppHeader(
              title: AppState.instance.strings.networkInsights,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.netChui.text),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(Spacing.lg),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        _buildMainStats(theme),
                        const SizedBox(height: Spacing.xl),
                        _buildPingChart(theme),
                        const SizedBox(height: Spacing.xl),
                        _buildSecondaryStats(theme),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStats(NetChuiColors theme) {
    final s = AppState.instance.strings;
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          _StatItem(
            label: s.latency.toUpperCase(),
            value: _currentStats?.pingMs.toInt().toString() ?? '--',
            unit: 'ms',
            color: _getPingColor(_currentStats?.pingMs ?? 0, theme),
            icon: Icons.speed_rounded,
          ),
          const SizedBox(height: 32),
          Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.text.withValues(alpha: 0),
                  theme.text.withValues(alpha: 0.08),
                  theme.text.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: s.jitter.toUpperCase(),
                  value: _currentStats?.jitterMs.toStringAsFixed(1) ?? '--',
                  unit: 'ms',
                  small: true,
                  icon: Icons.insights_rounded,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.text.withValues(alpha: 0.08),
              ),
              Expanded(
                child: _StatItem(
                  label: s.loss.toUpperCase(),
                  value: _currentStats?.packetLossPercent.toStringAsFixed(1) ?? '--',
                  unit: '%',
                  small: true,
                  icon: Icons.layers_clear_rounded,
                  color: (_currentStats?.packetLossPercent ?? 0) > 0 ? AppColors.warning : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPingChart(NetChuiColors theme) {
    final s = AppState.instance.strings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: theme.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                s.realTimePingTrend.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: theme.text.withValues(alpha: 0.8),
                ),
              ),
              const Spacer(),
              if (_pingSpots.isNotEmpty)
                Text(
                  '${s.average.toUpperCase()}: ${(_pingSpots.map((e) => e.y).reduce((a, b) => a + b) / _pingSpots.length).toStringAsFixed(0)}ms',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: theme.muted,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
            ],
          ),
        ),
        GlassCard(
          height: 220,
          padding: const EdgeInsets.fromLTRB(10, 24, 20, 10),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.text.withValues(alpha: 0.05),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        color: theme.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _pingSpots.isEmpty ? [const FlSpot(0, 0)] : _pingSpots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: theme.accent,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.accent.withValues(alpha: 0.15),
                        theme.accent.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryStats(NetChuiColors theme) {
    final info = AppState.instance.hardwareInfo;
    final s = AppState.instance.strings;
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _InfoRow(
            label: s.targetHost,
            value: '8.8.8.8 (Google DNS)',
            theme: theme,
            icon: Icons.dns_outlined,
          ),
          _InfoRow(
            label: s.ipAddress,
            value: info.ipAddress ?? 'Unknown',
            theme: theme,
            icon: Icons.router_outlined,
          ),
          _InfoRow(
            label: s.connection,
            value: AppState.instance.connectionLabel,
            theme: theme,
            icon: Icons.wifi_rounded,
          ),
        ],
      ),
    );
  }


  Color _getPingColor(double ms, NetChuiColors theme) {
    if (ms <= 0) return theme.muted;
    if (ms < 50) return AppColors.success;
    if (ms < 100) return AppColors.warning;
    return theme.accent;
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
    this.color,
    this.small = false,
    this.icon,
  });
  final String label;
  final String value;
  final String unit;
  final Color? color;
  final bool small;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.netChui;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: small ? 12 : 14, color: theme.muted),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: small ? 10 : 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: theme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: small ? 28 : 64,
                fontWeight: FontWeight.w900,
                color: color ?? theme.text,
                fontFamily: 'JetBrainsMono',
                letterSpacing: -2,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                fontSize: small ? 12 : 16,
                fontWeight: FontWeight.w700,
                color: theme.muted.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.theme, this.icon});
  final String label;
  final String value;
  final NetChuiColors theme;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: theme.muted),
            const SizedBox(width: 12),
          ],
          Text(label, style: TextStyle(color: theme.muted, fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: theme.text,
              fontWeight: FontWeight.w700,
              fontFamily: 'JetBrainsMono',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

