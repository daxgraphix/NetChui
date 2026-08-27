import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/models/speed_test_result.dart';
import 'package:net_chui/screens/diagnostics_screen.dart';
import 'package:net_chui/screens/dns_speed_test_screen.dart';
import 'package:net_chui/screens/lan_scanner_screen.dart';
import 'package:net_chui/screens/live_monitor_screen.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/base_modal.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/signal_chart.dart';
import 'package:net_chui/widgets/scan_radar.dart';
import 'package:net_chui/widgets/app_logo.dart';
import 'package:net_chui/widgets/offline_overlay.dart';
import 'package:net_chui/widgets/sparkline_chart.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'package:net_chui/widgets/network_detail_modal.dart';
import 'package:net_chui/screens/signal_info_screen.dart';
import 'package:net_chui/services/haptic_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isScanning = false;

  void _startScan() {
    setState(() => _isScanning = true);
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        setState(() => _isScanning = false);
        await AppState.instance.refreshHardwareInfo();
        
        // Log current network state
        final info = AppState.instance.hardwareInfo;
        if (!mounted) return;
        await AppState.instance.logToolResult(
          'SCAN',
          'Network Snapshot',
          AppState.instance.connectionLabel,
          {
            'rssi': info.rssi,
            'ssid': info.wifiSsid,
            'carrier': info.carrierName,
            'tech': info.networkGeneration,
            'ip': info.ipAddress,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final s = state.strings;
        final lastResult = state.lastHistoryEntry?.result;
        final info = state.hardwareInfo;

        return Scaffold(
          body: GradientBackground(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppHeader(title: s.scan),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: Spacing.md),
                      if (!state.isOnline) ...[
                        OfflineOverlay(onRetry: () => state.refreshHardwareInfo()),
                        const SizedBox(height: Spacing.lg),
                      ],
                      Center(
                        child: GestureDetector(
                          onTap: _isScanning ? null : _startScan,
                          child: Hero(
                            tag: 'app_logo',
                            child: AppLogo(
                              size: 80,
                              showBackground: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.xl),
                      _buildScanRadar(context),
                      const SizedBox(height: Spacing.xl),
                      _buildInfoCard(
                        context,
                        title: s.signalStability,
                        icon: Icons.analytics_outlined,
                        height: 180,
                        onTap: () async {
                          HapticService.selection();
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const SignalInfoScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, right: 10),
                          child: SignalChart(spots: state.signalHistory),
                        ),
                      ),
                      const SizedBox(height: Spacing.xl),
                      if (state.downloadTrend.length >= 2) ...[
                        _buildInfoCard(
                          context,
                          title: s.trend,
                          icon: Icons.trending_up_rounded,
                          height: 140,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, right: 10),
                            child: SparklineChart(values: state.downloadTrend, height: 80),
                          ),
                        ),
                        const SizedBox(height: Spacing.xl),
                      ],
                      _buildInfoCard(
                        context,
                        title: s.networkDetails,
                        icon: Icons.signal_cellular_alt_rounded,
                        onTap: () async {
                          HapticService.selection();
                          if (context.mounted) {
                            _showNetworkDetails(context, info);
                          }
                        },
                        child: Column(
                          children: [
                            _ScanRow(label: AppState.instance.strings.connection, value: state.connectionLabel),
                            if (info.networkGeneration != null)
                              _ScanRow(label: AppState.instance.strings.radio, value: info.networkGeneration!),
                            _ScanRow(label: AppState.instance.strings.carrier, value: info.carrierName ?? 'N/A'),
                            if (state.connectionLabel.contains('Wi‑Fi')) ...[
                              _ScanRow(label: s.ssid, value: info.wifiSsid ?? s.unknown),
                              _ScanRow(label: s.signalStrength, value: '${info.rssi ?? '—'} dBm'),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.xl),
                      _buildInfoCard(
                        context,
                        title: s.recommendations,
                        icon: Icons.tips_and_updates_outlined,
                        onTap: () async {
                          HapticService.selection();
                          if (context.mounted) {
                            _showRecommendationDetails(context, lastResult);
                          }
                        },
                        child: _buildRecommendations(lastResult),
                      ),
                      const SizedBox(height: Spacing.xl),
                      _buildToolGrid(context),
                      const SizedBox(height: 120),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: !state.isOnline
              ? null
              : Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: FloatingActionButton.extended(
                    onPressed: _isScanning ? null : _startScan,
                    backgroundColor: context.netChui.accent,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    icon: _isScanning
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : const Icon(Icons.radar_rounded, size: 24),
                    label: Text(
                      _isScanning ? s.scanning.toUpperCase() : s.scan.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 13),
                    ),
                  ),
                ),
        );
      },
    );
  }

  void _showNetworkDetails(BuildContext context, dynamic info) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NetworkDetailModal(info: info),
    );
  }

  void _showRecommendationDetails(BuildContext context, SpeedTestResult? result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecommendationDetailModal(result: result),
    );
  }

  Widget _buildScanRadar(BuildContext context) {
    return Center(
      child: ScanRadar(
        isScanning: _isScanning,
        centerIcon: Icon(
          AppState.instance.connectionLabel.contains('Wi‑Fi')
              ? Icons.wifi_rounded
              : Icons.signal_cellular_alt_rounded,
          size: 40,
          color: context.netChui.accent,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    double? height,
    VoidCallback? onTap,
  }) {
    final colors = context.netChui;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: Spacing.sm),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: colors.accent),
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: colors.muted,
                ),
              ),
              const Spacer(),
              if (onTap != null)
                Icon(Icons.arrow_forward_ios_rounded, size: 10, color: colors.border),
            ],
          ),
        ),
        GlassCard(
          onTap: onTap,
          height: height,
          padding: const EdgeInsets.all(Spacing.lg),
          child: child,
        ),
      ],
    );
  }

  Widget _buildToolGrid(BuildContext context) {
    final colors = context.netChui;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: Spacing.sm),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.grid_view_rounded, size: 14, color: colors.accent),
              ),
              const SizedBox(width: 10),
              Text(
                AppState.instance.strings.networkTools.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _ToolCard(
              title: AppState.instance.strings.liveMonitor,
              subtitle: 'Real-time stats',
              icon: Icons.monitor_heart_rounded,
              color: AppColors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveMonitorScreen())),
            ),
            _ToolCard(
              title: AppState.instance.strings.lanScanner,
              subtitle: 'Find devices',
              icon: Icons.devices_other_rounded,
              color: AppColors.purple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanScannerScreen())),
            ),
            _ToolCard(
              title: AppState.instance.strings.diagnostics,
              subtitle: 'Fix issues',
              icon: Icons.troubleshoot_rounded,
              color: AppColors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiagnosticsScreen())),
            ),
            _ToolCard(
              title: AppState.instance.strings.dnsSpeedTest,
              subtitle: 'Fastest DNS',
              icon: Icons.dns_rounded,
              color: colors.accent,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DnsSpeedTestScreen())),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendations(SpeedTestResult? result) {
    final s = AppState.instance.strings;
    if (result == null || !result.hasData) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(Icons.speed_rounded, size: 40, color: context.netChui.muted.withValues(alpha: 0.2)),
            const SizedBox(height: 12),
            Text(s.runTestToGetRecs,
                textAlign: TextAlign.center, style: TextStyle(color: context.netChui.muted, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    final dl = result.downloadMbps ?? 0;
    final ping = result.pingMs ?? 1000;

    final items = <_RecItem>[];
    final colors = context.netChui;

    if (dl > 50 && ping < 30) {
      items.add(_RecItem(Icons.movie_filter_rounded, s.rec4k, s.statusExcellent, s.rec4kDesc, colors.success));
      items.add(_RecItem(Icons.videogame_asset_rounded, s.recGaming, s.statusExcellent, s.recGamingDesc, colors.success));
    } else if (dl > 15 && ping < 60) {
      items.add(_RecItem(Icons.hd_rounded, s.recHd, s.statusGood, s.recHdDesc, colors.info));
      items.add(_RecItem(Icons.video_call_rounded, s.recVideoConf, s.statusGood, s.recVideoConfDesc, colors.info));
    } else if (dl > 5) {
      items.add(_RecItem(Icons.language_rounded, s.recBrowsing, s.statusFair, s.recBrowsingDesc, colors.warning));
      items.add(_RecItem(Icons.chat_bubble_outline_rounded, s.recSocial, s.statusFair, s.recSocialDesc, colors.warning));
    } else {
      items.add(_RecItem(Icons.warning_amber_rounded, s.recBasic, s.statusPoor, s.recBasicDesc, colors.accent));
    }

    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, size: 22, color: item.color),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.label, 
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: -0.3),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: item.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9, 
                                    fontWeight: FontWeight.w900, 
                                    color: item.color, 
                                    letterSpacing: 0.8
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description, 
                            style: TextStyle(
                              color: context.netChui.muted, 
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _RecItem {
  final IconData icon;
  final String label;
  final String status;
  final String description;
  final Color color;
  const _RecItem(this.icon, this.label, this.status, this.description, this.color);
}

class _ScanRow extends StatelessWidget {
  const _ScanRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: colors.muted,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'JetBrainsMono',
              color: colors.text,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.color,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.netChui;
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: -0.5),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}


class _RecommendationDetailModal extends StatelessWidget {
  const _RecommendationDetailModal({required this.result});
  final SpeedTestResult? result;

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    return BaseModal(
      title: s.recommendations,
      icon: Icons.tips_and_updates_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result == null || (result?.hasData ?? false) == false)
            Center(child: Text(s.runTestToGetRecs))
          else ...[
            Text(s.latestSpeedTest, style: TextStyle(color: context.netChui.muted, fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MiniStat(label: s.download.toUpperCase(), value: '${result!.downloadMbps?.toStringAsFixed(1)} Mbps'),
                _MiniStat(label: s.ping.toUpperCase(), value: '${result!.pingMs?.toInt()} ms'),
              ],
            ),
            const Divider(height: 32),
            _RecDetailItem(
              title: s.streamingAndVideo,
              description: result!.downloadMbps! > 25 ? s.rec4kDesc : s.recHdDesc,
              status: result!.downloadMbps! > 25 ? s.excellent : s.statusGood,
              icon: Icons.movie_filter_rounded,
              color: result!.downloadMbps! > 25 ? context.netChui.success : context.netChui.info,
            ),
            _RecDetailItem(
              title: s.gaming,
              description: result!.pingMs! < 50 ? s.recGamingDesc : 'Higher latency might affect fast-paced online gaming.',
              status: result!.pingMs! < 50 ? s.optimal : s.fair,
              icon: Icons.videogame_asset_rounded,
              color: result!.pingMs! < 50 ? context.netChui.success : context.netChui.warning,
            ),
            _RecDetailItem(
              title: s.workAndProductivity,
              description: s.recVideoConfDesc,
              status: s.stable,
              icon: Icons.work_outline_rounded,
              color: context.netChui.info,
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.netChui.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.netChui.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label, 
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: context.netChui.muted, letterSpacing: 1.0),
          ),
          const SizedBox(height: 4),
          Text(
            value, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'JetBrainsMono')
          ),
        ],
      ),
    );
  }
}

class _RecDetailItem extends StatelessWidget {
  const _RecDetailItem({required this.title, required this.description, required this.status, required this.icon, required this.color});
  final String title;
  final String description;
  final String status;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: -0.4)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status.toUpperCase(), 
                        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: 0.5)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description, 
                  style: TextStyle(
                    color: context.netChui.text.withValues(alpha: 0.7), 
                    fontSize: 13,
                    height: 1.4,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

