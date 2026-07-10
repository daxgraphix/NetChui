import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/services/network_analysis_service.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'dart:async';

class DnsServerIP {
  final String provider;
  final String ip;
  final String location;

  const DnsServerIP({
    required this.provider,
    required this.ip,
    required this.location,
  });
}

class DnsSpeedTestScreen extends StatefulWidget {
  const DnsSpeedTestScreen({super.key});

  @override
  State<DnsSpeedTestScreen> createState() => _DnsSpeedTestScreenState();
}

class _DnsSpeedTestScreenState extends State<DnsSpeedTestScreen> {
  final _service = NetworkAnalysisService();
  bool _isTesting = false;
  final Map<String, double?> _results = {};
  final Map<String, bool> _loadingMap = {};

  static const List<DnsServerIP> _servers = [
    DnsServerIP(provider: 'Cloudflare', ip: '1.1.1.1', location: 'Global / Anycast'),
    DnsServerIP(provider: 'Google Public DNS', ip: '8.8.8.8', location: 'Global / Anycast'),
    DnsServerIP(provider: 'OpenDNS', ip: '208.67.222.222', location: 'Cisco / Global'),
    DnsServerIP(provider: 'Quad9', ip: '9.9.9.9', location: 'IBM / Secure'),
    DnsServerIP(provider: 'AdGuard DNS', ip: '94.140.14.14', location: 'Cyprus / Privacy'),
    DnsServerIP(provider: 'CleanBrowsing', ip: '185.228.168.9', location: 'Family Filter'),
    DnsServerIP(provider: 'AliDNS', ip: '223.5.5.5', location: 'China / Alibaba'),
    DnsServerIP(provider: 'Level3', ip: '4.2.2.1', location: 'USA / CenturyLink'),
    DnsServerIP(provider: 'Verisign', ip: '64.6.64.6', location: 'USA / Secure'),
    DnsServerIP(provider: 'Control D', ip: '76.76.2.0', location: 'Customizable'),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-start test for the first few? No, let user start.
  }

  Future<void> _testIP(String ip) async {
    if (mounted) setState(() => _loadingMap[ip] = true);

    try {
      // Run 3 pings and take the average for better accuracy
      final List<double> pings = [];
      for (int i = 0; i < 2; i++) {
        final res = await _service.testConnection(ip);
        if (res.time != null) pings.add(res.time!.inMilliseconds.toDouble());
      }
      
      if (mounted) {
        setState(() {
          if (pings.isNotEmpty) {
            _results[ip] = pings.reduce((a, b) => a + b) / pings.length;
          } else {
            _results[ip] = -1; // Error/Timeout
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _results[ip] = -1);
    } finally {
      if (mounted) setState(() => _loadingMap[ip] = false);
    }
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isTesting = true;
      _results.clear();
    });

    // Run in parallel but with a limit to not saturate connection
    final chunks = <List<DnsServerIP>>[];
    for (var i = 0; i < _servers.length; i += 3) {
      chunks.add(_servers.sublist(i, i + 3 > _servers.length ? _servers.length : i + 3));
    }

    for (final chunk in chunks) {
      if (!mounted) break;
      await Future.wait(chunk.map((s) => _testIP(s.ip)));
    }

    if (mounted) {
      setState(() => _isTesting = false);
      
      // Log results
      final best = _results.entries
          .where((e) => e.value != null && e.value! > 0)
          .toList()
        ..sort((a, b) => a.value!.compareTo(b.value!));
      
      if (best.isNotEmpty) {
        final top = _servers.firstWhere((s) => s.ip == best.first.key);
        await AppState.instance.logToolResult(
          'DNS_BENCHMARK',
          AppState.instance.strings.dnsBenchmark,
          AppState.instance.strings.dnsBestResult(top.provider, best.first.value!.toInt().toString()),
          _results.map((k, v) => MapEntry(k, v?.toString())),
          category: 'PERFORMANCE',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedServers = List<DnsServerIP>.from(_servers);
    if (!_isTesting && _results.isNotEmpty) {
       sortedServers.sort((a, b) {
         final resA = _results[a.ip] ?? 9999;
         final resB = _results[b.ip] ?? 9999;
         final valA = resA < 0 ? 9998 : resA;
         final valB = resB < 0 ? 9998 : resB;
         return valA.compareTo(valB);
       });
    }

    final s = AppState.instance.strings;

    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppHeader(
              title: s.dnsSpeedTest,
              expandedHeight: 120,
            ),
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final server = sortedServers[index];
                    final latency = _results[server.ip];
                    final isLoading = _loadingMap[server.ip] ?? false;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.md),
                      child: Hero(
                        tag: 'dns_${server.ip}',
                        child: _DnsCard(
                          server: server,
                          latency: latency,
                          isLoading: isLoading,
                          rank: _results.isNotEmpty && !_isTesting && (latency != null && latency > 0) ? index + 1 : null,
                          onTest: () => _testIP(server.ip),
                        ),
                      ),
                    );
                  },
                  childCount: sortedServers.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isTesting ? null : _runAllTests,
        backgroundColor: context.netChui.accent,
        foregroundColor: Colors.white,
        icon: _isTesting 
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Icon(Icons.bolt_rounded),
        label: Text(_isTesting ? s.benchmarking : s.runFullBenchmark),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: context.netChui.accent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppState.instance.strings.dnsLatencyHint,
                style: TextStyle(fontSize: 13, color: context.netChui.text.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DnsCard extends StatelessWidget {
  const _DnsCard({
    required this.server,
    this.latency,
    required this.isLoading,
    required this.onTest,
    this.rank,
  });

  final DnsServerIP server;
  final double? latency;
  final bool isLoading;
  final VoidCallback onTest;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    final bool isError = latency != null && latency! < 0;
    final bool hasData = latency != null && !isError;
    final Color color = hasData ? _getLatencyColor(latency!) : context.netChui.subtle;

    return GlassCard(
      padding: EdgeInsets.zero,
      borderColor: rank == 1 ? context.netChui.accent : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            if (rank == 1)
              Positioned(
                top: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.netChui.accent,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                  ),
                  child: const Text('FASTEST', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        rank?.toString() ?? server.provider[0],
                        style: TextStyle(
                          color: hasData ? color : context.netChui.muted,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(server.provider, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: -0.3)),
                        const SizedBox(height: 2),
                        Text(server.ip, style: TextStyle(color: context.netChui.muted, fontSize: 13, fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w600)),
                        Text(server.location, style: TextStyle(color: context.netChui.muted.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  if (isLoading)
                    SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: context.netChui.accent))
                  else if (isError)
                    const Icon(Icons.error_outline_rounded, color: AppColors.orange)
                  else if (hasData)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${latency!.toInt()}ms',
                          style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18, fontFamily: 'JetBrainsMono'),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 64, height: 6,
                          decoration: BoxDecoration(
                            color: context.netChui.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: (1 - (latency! / 200)).clamp(0.1, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      onPressed: onTest,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.netChui.accent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow_rounded, color: context.netChui.accent, size: 20),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLatencyColor(double ms) {
    if (ms < 30) return AppColors.success;
    if (ms < 70) return AppColors.info;
    if (ms < 150) return AppColors.warning;
    return AppColors.accent;
  }
}
