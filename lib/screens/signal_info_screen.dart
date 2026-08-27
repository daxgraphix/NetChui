import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/section_title.dart';
import 'package:net_chui/services/hardware_service.dart';

class SignalInfoScreen extends StatefulWidget {
  const SignalInfoScreen({super.key});

  @override
  State<SignalInfoScreen> createState() => _SignalInfoScreenState();
}

class _SignalInfoScreenState extends State<SignalInfoScreen> {
  Timer? _timer;
  final List<FlSpot> _signalSpots = [];
  final List<FlSpot> _trafficDownSpots = [];
  final List<FlSpot> _trafficUpSpots = [];
  int _seconds = 0;
  
  // Simulated traffic for demonstration if real-time traffic hook is missing
  double _lastDown = 0;
  double _lastUp = 0;

  @override
  void initState() {
    super.initState();
    _startUpdates();
  }

  void _startUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await AppState.instance.refreshHardwareInfo();
      final info = AppState.instance.hardwareInfo;
      
      if (mounted) {
        setState(() {
          _seconds++;
          
          // RSSI or RSRP
          double signalValue = (info.rssi ?? -100).toDouble();
          if (info.rsrp != null) signalValue = info.rsrp!.toDouble();
          
          _signalSpots.add(FlSpot(_seconds.toDouble(), signalValue));
          if (_signalSpots.length > 60) _signalSpots.removeAt(0);

          // Traffic simulation (Replace with real traffic data if available)
          final random = Random();
          _lastDown = 500000 + random.nextDouble() * 2000000; // bps
          _lastUp = 100000 + random.nextDouble() * 500000; // bps
          
          _trafficDownSpots.add(FlSpot(_seconds.toDouble(), _lastDown));
          _trafficUpSpots.add(FlSpot(_seconds.toDouble(), _lastUp));
          
          if (_trafficDownSpots.length > 60) {
            _trafficDownSpots.removeAt(0);
            _trafficUpSpots.removeAt(0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final info = AppState.instance.hardwareInfo;
        final isWifi = AppState.instance.connectionLabel.contains('Wi‑Fi');

        return Scaffold(
          body: GradientBackground(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
              AppHeader(
                  title: AppState.instance.strings.signalDetails,
                  expandedHeight: 120,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.netChui.text),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(isWifi, info),
                      const SizedBox(height: Spacing.xl),
                      _buildLiveMetrics(info),
                      const SizedBox(height: Spacing.xl),
                      SectionTitle(AppState.instance.strings.signalStrengthGraph),
                      _buildSignalGraph(info),
                      const SizedBox(height: Spacing.xl),
                      SectionTitle(AppState.instance.strings.networkTrafficGraph),
                      _buildTrafficGraph(),
                      const SizedBox(height: Spacing.xl),
                      if (isWifi) ...[
                        SectionTitle(AppState.instance.strings.wifiDetails),
                        _buildWifiDetails(info),
                      ] else ...[
                        SectionTitle(AppState.instance.strings.cellularDetails),
                        _buildCellularDetails(info),
                      ],
                      const SizedBox(height: Spacing.xl),
                      SectionTitle(AppState.instance.strings.ipAndNetwork),
                      _buildNetworkInfo(info),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isWifi, HardwareInfo info) {
    final colors = context.netChui;
    final iconColor = isWifi ? colors.secondary : colors.warning;
    
    return GlassCard(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: iconColor.withValues(alpha: 0.15)),
                      ),
                      child: Icon(
                        isWifi ? Icons.wifi_rounded : Icons.signal_cellular_alt_rounded,
                        color: iconColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: Spacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isWifi ? (info.wifiSsid ?? 'Wi-Fi') : (info.carrierName ?? 'Mobile Data'),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.8),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            isWifi ? 'Connected via WLAN' : '${info.networkGeneration ?? 'Cellular'} Connection',
                            style: TextStyle(color: colors.muted, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(isWifi ? info.rssi : info.rsrp) ?? '--'}',
                          style: TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.w900, 
                            color: colors.text,
                            fontFamily: 'JetBrainsMono',
                            letterSpacing: -1.5,
                          ),
                        ),
                        Text('dBm', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: colors.muted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalGraph(HardwareInfo info) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(Spacing.sm, Spacing.xl, Spacing.sm, Spacing.sm),
      child: SizedBox(
        height: 150,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: _signalSpots.map((s) {
                  // Normalize dBm to 0-100%
                  // -100 is 0%, -50 is 100%
                  double percent = ((s.y + 100) / 50 * 100).clamp(0, 100);
                  return FlSpot(s.x, percent);
                }).toList(),
                isCurved: true,
                color: context.netChui.accent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: context.netChui.accent.withValues(alpha: 0.1),
                ),
              ),
            ],
            minY: 0,
            maxY: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficGraph() {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(Spacing.sm, Spacing.lg, Spacing.sm, Spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _TrafficIndicator(label: 'DOWN', color: AppColors.secondary, value: _lastDown),
                const SizedBox(width: 16),
                _TrafficIndicator(label: 'UP', color: AppColors.success, value: _lastUp),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.netChui.border.withValues(alpha: 0.05),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _trafficDownSpots,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: AppColors.secondary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true, 
                      color: AppColors.secondary.withValues(alpha: 0.1)
                    ),
                  ),
                  LineChartBarData(
                    spots: _trafficUpSpots,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: AppColors.success,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true, 
                      color: AppColors.success.withValues(alpha: 0.1)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWifiDetails(HardwareInfo info) {
    final s = AppState.instance.strings;
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _DetailRow(label: 'Link Speed', value: '${info.linkSpeed ?? '--'} Mbps', isMonospace: true),
          _DetailRow(label: s.frequency, value: '${info.frequency ?? '--'} MHz', isMonospace: true),
          _DetailRow(label: s.channel, value: '${info.channel ?? '--'}', isMonospace: true),
          _DetailRow(label: s.standard, value: info.wifiStandard ?? 'Unknown'),
          _DetailRow(label: 'BSSID', value: info.wifiBssid ?? '--', isMonospace: true),
        ],
      ),
    );
  }

  Widget _buildCellularDetails(HardwareInfo info) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _DetailRow(label: 'SIM Type', value: info.carrierName ?? 'Unknown'),
          _DetailRow(label: 'SIM State', value: info.simState ?? 'Unknown'),
          _DetailRow(label: 'Data Type', value: info.dataType ?? info.networkGeneration ?? 'Unknown'),
          _DetailRow(label: 'RTT Support', value: (info.rttSupported ?? false) ? 'Supported' : 'Not Supported'),
          _DetailRow(label: 'RSRP', value: '${info.rsrp ?? '--'} dBm', isMonospace: true),
        ],
      ),
    );
  }

  Widget _buildNetworkInfo(HardwareInfo info) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _DetailRow(label: 'Private IP', value: info.ipAddress ?? '--', isMonospace: true),
          _DetailRow(label: 'Public IP', value: info.publicIp ?? 'Fetching...', isMonospace: true),
          _DetailRow(label: 'Gateway', value: info.gateway ?? '--', isMonospace: true),
          _DetailRow(label: 'Netmask', value: info.netmask ?? '--', isMonospace: true),
          _DetailRow(label: 'DNS', value: info.dnsServers?.join(', ') ?? '--', isMonospace: true),
        ],
      ),
    );
  }

  Widget _buildLiveMetrics(HardwareInfo info) {
    return Row(
      children: [
        Expanded(
          child: _LiveMetric(
            label: 'SIGNAL',
            value: '${(info.rsrp ?? info.rssi) ?? '--'}',
            unit: 'dBm',
            icon: Icons.sensors_rounded,
            color: context.netChui.accent,
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: _LiveMetric(
            label: 'LATENCY',
            value: '${AppState.instance.lastHistoryEntry?.result.pingMs?.toInt() ?? '--'}',
            unit: 'ms',
            icon: Icons.speed_rounded,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}

class _TrafficIndicator extends StatelessWidget {
  const _TrafficIndicator({required this.label, required this.color, required this.value});
  final String label;
  final Color color;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ${(value / 1000).toStringAsFixed(1)} kbps',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, fontFamily: 'JetBrainsMono'),
        ),
      ],
    );
  }
}

class _LiveMetric extends StatelessWidget {
  const _LiveMetric({required this.label, required this.value, required this.unit, required this.icon, required this.color});
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;
    return GlassCard(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.15)),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                label, 
                style: TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 1.5, 
                  color: colors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value, 
                style: const TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900,
                  fontFamily: 'JetBrainsMono',
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit, 
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.w800, 
                  color: colors.muted.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.isMonospace = false});
  final String label;
  final String value;
  final bool isMonospace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.netChui.muted, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(width: Spacing.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: context.netChui.text,
                fontWeight: FontWeight.w700,
                fontFamily: isMonospace ? 'JetBrainsMono' : null,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
