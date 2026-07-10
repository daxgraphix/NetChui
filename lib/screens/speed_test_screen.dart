import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/l10n/app_localizations.dart';
import 'package:net_chui/models/speed_test_phase.dart';
import 'package:net_chui/models/speed_test_result.dart';
import 'package:net_chui/services/speed_test_service.dart';
import 'package:net_chui/services/haptic_service.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/comparison_chip.dart';
import 'package:net_chui/widgets/connection_banner.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/metric_card.dart';
import 'package:net_chui/widgets/speed_gauge.dart';
import 'package:net_chui/widgets/test_mode_chips.dart';
import 'package:net_chui/widgets/network_detail_modal.dart';
import 'package:net_chui/widgets/offline_overlay.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:share_plus/share_plus.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  final _service = SpeedTestService();

  SpeedTestPhase _phase = SpeedTestPhase.idle;
  SpeedTestResult _result = const SpeedTestResult();
  double? _liveMbps;
  double? _livePingMs;
  bool _cancelled = false;
  String? _errorMessage;

  bool get _isRunning =>
      _phase != SpeedTestPhase.idle &&
      _phase != SpeedTestPhase.done &&
      _phase != SpeedTestPhase.error;

  @override
  void dispose() {
    _cancelled = true;
    _service.dispose();
    super.dispose();
  }

  Color _phaseAccent(SpeedTestPhase phase, BuildContext context) {
    return switch (phase) {
      SpeedTestPhase.ping => AppColors.blue,
      SpeedTestPhase.download => context.netChui.accent,
      SpeedTestPhase.upload => Colors.deepPurpleAccent,
      SpeedTestPhase.done => AppColors.green,
      SpeedTestPhase.error => context.netChui.accent,
      _ => context.netChui.accent,
    };
  }

  double? get _gaugeMbps {
    if (_liveMbps != null) return _liveMbps;
    return switch (_phase) {
      SpeedTestPhase.download => _result.downloadMbps,
      SpeedTestPhase.upload => _result.uploadMbps,
      SpeedTestPhase.done => _result.downloadMbps,
      _ => null,
    };
  }

  String _phaseLabel(AppLocalizations s) {
    if (_errorMessage != null) return _errorMessage!;
    return switch (_phase) {
      SpeedTestPhase.idle => s.ready,
      SpeedTestPhase.ping => s.measuringPing,
      SpeedTestPhase.download => s.measuringDownload,
      SpeedTestPhase.upload => s.measuringUpload,
      SpeedTestPhase.done => s.complete,
      SpeedTestPhase.error => s.errorGeneric,
    };
  }

  Future<void> _startTest() async {
    final state = AppState.instance;
    final s = state.strings;

    if (_isRunning) return;
    if (!state.isOnline) {
      setState(() {
        _phase = SpeedTestPhase.error;
        _errorMessage = s.offline;
      });
      return;
    }

    HapticService.medium();
    setState(() {
      _phase = SpeedTestPhase.ping;
      _result = const SpeedTestResult();
      _liveMbps = null;
      _livePingMs = null;
      _errorMessage = null;
      _cancelled = false;
    });

    try {
      final result = await _service.runTest(
        config: state.speedTestConfig,
        isCancelled: () => _cancelled,
        onProgress: (phase, {liveMbps, livePingMs, partial}) {
          if (!mounted || _cancelled) return;
          setState(() {
            _phase = phase;
            if (liveMbps != null) _liveMbps = liveMbps;
            if (livePingMs != null) _livePingMs = livePingMs;
            if (partial != null) _result = partial;
            if (phase == SpeedTestPhase.done) {
              _liveMbps = null;
              _livePingMs = null;
            }
          });
        },
      );

      if (!mounted || _cancelled) return;

      await state.addHistoryEntry(
        result: result,
        connectionType: state.connectionLabel,
      );

      await state.logToolResult(
        'SPEED_TEST',
        'Speed Test Complete',
        '${result.downloadMbps?.toStringAsFixed(1)} Mbps Down',
        {
          'download': result.downloadMbps,
          'upload': result.uploadMbps,
          'ping': result.pingMs,
          'isp': result.isp,
          'location': result.locationHint,
        },
        category: 'PERFORMANCE',
        severity: result.downloadMbps != null && result.downloadMbps! < 10 ? 2 : 0,
      );

      HapticService.light();
    } on SpeedTestException catch (e) {
      if (!mounted || _cancelled) return;
      setState(() {
        _phase = SpeedTestPhase.error;
        _errorMessage = e.message;
      });
    } on Object {
      if (!mounted || _cancelled) return;
      setState(() {
        _phase = SpeedTestPhase.error;
        _errorMessage = s.errorGeneric;
      });
    }
  }

  void _stopTest() {
    HapticService.selection();
    setState(() {
      _cancelled = true;
      _phase = SpeedTestPhase.idle;
      _liveMbps = null;
      _livePingMs = null;
    });
  }

  void _shareResult() {
    Share.share(_result.shareText());
  }

  void _showNetworkDetails(BuildContext context, dynamic info) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NetworkDetailModal(info: info),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final s = state.strings;
        final phase = _phase == SpeedTestPhase.error
            ? SpeedTestPhase.idle
            : _phase;
        final displayPhase = _phase == SpeedTestPhase.error
            ? SpeedTestPhase.idle
            : _phase;

        return Scaffold(
          body: GradientBackground(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppHeader(
                  title: s.appName,
                  actions: [
                    if (_result.hasData && !_isRunning)
                      IconButton(
                        onPressed: _shareResult,
                        tooltip: s.share,
                        icon: Icon(Icons.ios_share_rounded, color: context.netChui.text),
                      ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 20),
                      ConnectionBanner(
                        label: state.isOnline ? state.connectionLabel : s.offline,
                        isOnline: state.isOnline,
                        healthScore: state.networkHealthScore,
                        ip: _result.publicIp,
                        location: _result.locationHint,
                        isp: _result.isp,
                        onTap: () => _showNetworkDetails(context, state.hardwareInfo),
                      ),
                      if (!state.isOnline) ...[
                        const SizedBox(height: 12),
                        OfflineOverlay(onRetry: () => state.refreshHardwareInfo()),
                      ],
                      if (_phase == SpeedTestPhase.error && _errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: _ErrorBanner(
                            message: _errorMessage!,
                            onRetry: _startTest,
                            retryLabel: s.retry,
                          ),
                        ),
                      const SizedBox(height: 16),
                      TestModeChips(
                        selected: state.settings.testMode,
                        enabled: !_isRunning,
                        onSelected: state.setTestMode,
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: SpeedGauge(
                          valueMbps: _gaugeMbps,
                          progress: phase.progress,
                          isRunning: _isRunning,
                          phaseLabel: _phaseLabel(s),
                          phaseAccent: _phaseAccent(displayPhase, context),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildMetrics(context, s, state),
                      const SizedBox(height: 24),
                      _buildActions(context, s, state.isOnline),
                      const SizedBox(height: 24),
                      Center(
                        child: Opacity(
                          opacity: 0.6,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flash_on_rounded, size: 12, color: context.netChui.accent),
                              const SizedBox(width: 4),
                              Text(
                                s.poweredBy.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
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

  Widget _buildMetrics(BuildContext context, AppLocalizations s, AppState state) {
    final pingSubtitle = _result.pingMinMs != null
        ? '${_result.pingMinMs!.round()}–${_result.pingMaxMs!.round()} · ${s.jitter} ${_result.jitterMs?.toStringAsFixed(1) ?? '—'}'
        : null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.network_ping_rounded,
                label: s.ping,
                value: _formatPing(_livePingMs ?? _result.pingMs),
                unit: 'ms',
                subtitle: pingSubtitle,
                accent: AppColors.blue,
                isActive: _phase == SpeedTestPhase.ping,
                semanticsLabel: s.ping,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: MetricCard(
                icon: Icons.arrow_downward_rounded,
                label: s.download,
                value: _formatMbps(_result.downloadMbps),
                unit: 'Mbps',
                accent: context.netChui.accent,
                isActive: _phase == SpeedTestPhase.download,
                semanticsLabel: s.download,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: MetricCard(
                icon: Icons.arrow_upward_rounded,
                label: s.upload,
                value: _formatMbps(_result.uploadMbps),
                unit: 'Mbps',
                accent: Colors.deepPurpleAccent,
                isActive: _phase == SpeedTestPhase.upload,
                semanticsLabel: s.upload,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ComparisonChip(
              comparison: state.comparePing(_result.pingMs),
              unit: 'ms',
            ),
            const SizedBox(width: 8),
            ComparisonChip(
              comparison: state.compareDownload(_result.downloadMbps),
            ),
            const SizedBox(width: 8),
            ComparisonChip(
              comparison: state.compareUpload(_result.uploadMbps),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations s, bool online) {
    final colors = context.netChui;
    if (_isRunning) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _stopTest,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                foregroundColor: context.netChui.accent,
                side: BorderSide(color: context.netChui.accent),
              ),
              child: Text(s.stop, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: SizedBox(
              height: 52,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ),
        ],
      );
    }

    final isDone = _phase == SpeedTestPhase.done;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: online ? _startTest : null,
        style: FilledButton.styleFrom(
          backgroundColor: context.netChui.accent,
          foregroundColor: colors.surface,
          disabledBackgroundColor: colors.surface.withValues(alpha: 0.3),
        ),
        child: Text(
          isDone ? s.testAgain : s.startTest,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static String _formatPing(double? ms) {
    if (ms == null) return '—';
    return ms.toStringAsFixed(0);
  }

  static String _formatMbps(double? mbps) {
    if (mbps == null) return '—';
    if (mbps >= 1000) return (mbps / 1000).toStringAsFixed(1);
    if (mbps >= 100) return mbps.toStringAsFixed(0);
    if (mbps >= 10) return mbps.toStringAsFixed(1);
    return mbps.toStringAsFixed(2);
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    required this.onRetry,
    required this.retryLabel,
  });

  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.netChui.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.netChui.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.netChui.accent, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
          TextButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    );
  }
}
