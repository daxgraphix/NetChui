import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/screens/insights_screen.dart';
import 'package:net_chui/services/report_service.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/glass_card.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final lastTest = state.lastHistoryEntry;
        final hardware = state.hardwareInfo;

        return Scaffold(
          body: GradientBackground(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppHeader(
                  title: state.strings.report,
                  expandedHeight: 120,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.netChui.text),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf_rounded),
                      onPressed: () => _showExportOptions(context),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                        _buildSummaryCard(context, state),
                      const SizedBox(height: Spacing.xl),
                      _buildSectionTitle(context, state.strings.networkScore),
                      const GlassCard(
                        padding: EdgeInsets.all(Spacing.lg),
                        child: InsightsScreen(isInternal: true),
                      ),
                      const SizedBox(height: Spacing.xl),
                      _buildSectionTitle(context, state.strings.deviceAndSystem),
                      _buildInfoCard(context, [
                        _InfoRow(label: state.strings.model, value: hardware.model ?? 'Unknown'),
                        _InfoRow(label: state.strings.brand, value: hardware.brand ?? 'Unknown'),
                        _InfoRow(label: state.strings.os, value: 'Android ${hardware.osVersion ?? "Unknown"}', isMonospace: true),
                        _InfoRow(label: state.strings.level, value: 'API ${hardware.sdkVersion ?? "—"}', isMonospace: true),
                      ]),
                      const SizedBox(height: Spacing.xl),
                      _buildSectionTitle(context, state.strings.networkState),
                      _buildInfoCard(context, [
                        _InfoRow(label: state.strings.connection, value: state.connectionLabel),
                        _InfoRow(label: state.strings.publicIp, value: lastTest?.result.publicIp ?? '—', isMonospace: true),
                      ]),
                      const SizedBox(height: Spacing.xl),
                      _buildSectionTitle(context, state.strings.lastTestPerformance),
                      if (lastTest != null)
                        _buildInfoCard(context, [
                          _InfoRow(label: state.strings.download, value: '${lastTest.result.downloadMbps?.toStringAsFixed(1)} Mbps', isMonospace: true),
                          _InfoRow(label: state.strings.upload, value: '${lastTest.result.uploadMbps?.toStringAsFixed(1)} Mbps', isMonospace: true),
                          _InfoRow(label: state.strings.ping, value: '${lastTest.result.pingMs?.toStringAsFixed(0)} ms', isMonospace: true),
                          _InfoRow(label: state.strings.jitter, value: '${lastTest.result.jitterMs?.toStringAsFixed(1)} ms', isMonospace: true),
                          _InfoRow(label: state.strings.isp, value: lastTest.result.isp ?? '—'),
                          _InfoRow(label: state.strings.date, value: DateFormat.yMMMMd().add_jm().format(lastTest.timestamp)),
                        ])
                      else
                        _buildEmptyCard(context, state.strings.noTestDataYet),
                      const SizedBox(height: Spacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.icon(
                          onPressed: () => _showExportOptions(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: context.netChui.accent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.share_rounded),
                          label: Text(state.strings.exportReports, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                        ),
                      ),
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

  void _showExportOptions(BuildContext context) {
    final s = AppState.instance.strings;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.netChui.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.netChui.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              Text(
                s.exportOptions,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.green.withValues(alpha: 0.1),
                  child: const Icon(Icons.health_and_safety_rounded, color: AppColors.green),
                ),
                title: Text(s.healthScoreAudit, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(s.healthScoreAuditSubtitle),
                onTap: () {
                  Navigator.pop(context);
                  ReportService.instance.generateHealthReport();
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.orange.withValues(alpha: 0.1),
                  child: const Icon(Icons.security_rounded, color: AppColors.orange),
                ),
                title: Text(s.securityAudit, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(s.securityAuditSubtitle),
                onTap: () {
                  Navigator.pop(context);
                  ReportService.instance.generateSecurityReport();
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.netChui.accent.withValues(alpha: 0.1),
                  child: Icon(Icons.summarize_rounded, color: context.netChui.accent),
                ),
                title: Text(s.fullNetworkAudit, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(s.fullNetworkAuditSubtitle),
                onTap: () {
                  Navigator.pop(context);
                  ReportService.instance.generateComprehensiveReport();
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.blue.withValues(alpha: 0.1),
                  child: const Icon(Icons.history_rounded, color: AppColors.blue),
                ),
                title: Text(s.performanceLogs, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(s.performanceLogsSubtitle),
                onTap: () {
                  Navigator.pop(context);
                  ReportService.instance.generateFilteredReport(category: 'PERFORMANCE');
                },
              ),
            ],
          ),
        ),
      ),
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
            title,
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

  Widget _buildSummaryCard(BuildContext context, AppState state) {
    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InsightsScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.netChui.accent.withValues(alpha: 0.15),
              context.netChui.accent.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppState.instance.strings.networkState,
                  style: TextStyle(
                    color: context.netChui.accent, 
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
                Icon(Icons.wifi_tethering_rounded, color: context.netChui.accent, size: 16),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Text(
              state.isOnline ? state.connectionLabel : 'Offline',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            const SizedBox(height: Spacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MiniStat(label: state.strings.download, value: state.lastHistoryEntry?.result.downloadMbps?.toStringAsFixed(1) ?? '0.0', unit: 'Mb/s'),
                _MiniStat(label: state.strings.upload, value: state.lastHistoryEntry?.result.uploadMbps?.toStringAsFixed(1) ?? '0.0', unit: 'Mb/s'),
                _MiniStat(label: state.strings.ping, value: state.lastHistoryEntry?.result.pingMs?.toStringAsFixed(0) ?? '0', unit: 'ms'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }

  Widget _buildEmptyCard(BuildContext context, String message) {
    return GlassCard(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xxl),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, color: context.netChui.subtle, size: 48),
          const SizedBox(height: 16),
          Text(
            message, 
            style: TextStyle(
              color: context.netChui.muted, 
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.isMonospace = false});
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, this.unit});
  final String label;
  final String value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(), 
          style: TextStyle(
            color: context.netChui.muted, 
            fontSize: 9, 
            fontWeight: FontWeight.w800, 
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value, 
              style: TextStyle(
                color: context.netChui.text, 
                fontSize: 20, 
                fontWeight: FontWeight.w900,
                fontFamily: 'JetBrainsMono',
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit!, 
                style: TextStyle(
                  color: context.netChui.muted.withValues(alpha: 0.8), 
                  fontSize: 10, 
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
