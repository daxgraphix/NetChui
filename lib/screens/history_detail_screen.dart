import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/models/history_entry.dart';
import 'package:net_chui/models/test_mode.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/glass_card.dart';
import 'package:net_chui/services/report_service.dart';
import 'package:screenshot/screenshot.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key, required this.entry});

  final HistoryEntry entry;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  void _showExportMenu(BuildContext context) {
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
                'EXPORT REPORT',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: context.netChui.muted,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.blue.withValues(alpha: 0.1),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.blue),
                ),
                title: const Text('Share PDF Report', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Detailed document with all metrics'),
                onTap: () {
                  Navigator.pop(context);
                  ReportService.instance.generateAndSharePdf(widget.entry);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.green.withValues(alpha: 0.1),
                  child: const Icon(Icons.image_rounded, color: AppColors.green),
                ),
                title: const Text('Share Image Report', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('High-quality snapshot for social media'),
                onTap: () async {
                  Navigator.pop(context);
                  final bytes = await _screenshotController.capture();
                  if (bytes != null) {
                    await ReportService.instance.shareImage(bytes, 'NetChui_Report_${widget.entry.id}');
                  }
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.orange.withValues(alpha: 0.1),
                  child: const Icon(Icons.print_rounded, color: AppColors.orange),
                ),
                title: const Text('Print Report', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  ReportService.instance.printPdf(widget.entry);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.netChui.text.withValues(alpha: 0.1),
                  child: Icon(Icons.copy_rounded, color: context.netChui.text),
                ),
                title: const Text('Copy as Text', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  Share.share(widget.entry.result.shareText());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    final r = widget.entry.result;

    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        body: GradientBackground(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              AppHeader(
                title: s.details,
                expandedHeight: 120,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.netChui.text),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    onPressed: () => _showExportMenu(context),
                    icon: const Icon(Icons.share_rounded),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMainStats(context, widget.entry),
                    const SizedBox(height: Spacing.xl),
                    _buildSection(
                      context,
                      title: s.connectionInfo,
                      icon: Icons.info_outline_rounded,
                      children: [
                        _DetailRow(label: s.ipAddress, value: r.publicIp ?? '—', isMonospace: true),
                        _DetailRow(label: s.serviceProvider, value: r.isp ?? '—'),
                        _DetailRow(label: s.location, value: r.locationHint ?? '—'),
                        _DetailRow(label: s.type, value: widget.entry.connectionType),
                      ],
                    ),
                    const SizedBox(height: Spacing.xl),
                    _buildSection(
                      context,
                      title: s.testInfo,
                      icon: Icons.speed_rounded,
                      children: [
                        _DetailRow(label: s.mode, value: widget.entry.testMode.label(context)),
                        _DetailRow(label: s.size, value: widget.entry.testSizeName),
                        _DetailRow(label: s.date, value: DateFormat.yMMMMd().add_jm().format(widget.entry.timestamp)),
                        _DetailRow(label: s.server, value: widget.entry.serverId),
                      ],
                    ),
                    const SizedBox(height: Spacing.xl),
                    _buildSection(
                      context,
                      title: s.latencyDetails,
                      icon: Icons.timer_outlined,
                      children: [
                        _DetailRow(label: s.ping, value: '${r.pingMs?.toStringAsFixed(1) ?? "—"} ms', isMonospace: true),
                        _DetailRow(
                          label: 'Min / Max', 
                          value: '${r.pingMinMs?.toStringAsFixed(1) ?? "—"} / ${r.pingMaxMs?.toStringAsFixed(1) ?? "—"} ms',
                          isMonospace: true,
                        ),
                        _DetailRow(label: s.jitter, value: '${r.jitterMs?.toStringAsFixed(1) ?? "—"} ms', isMonospace: true),
                        _DetailRow(label: s.downloadPing, value: '${r.downloadPingMs?.toStringAsFixed(1) ?? "—"} ms', isMonospace: true),
                        _DetailRow(label: s.uploadPing, value: '${r.uploadPingMs?.toStringAsFixed(1) ?? "—"} ms', isMonospace: true),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainStats(BuildContext context, HistoryEntry entry) {
    final s = AppState.instance.strings;
    final r = entry.result;
    return GlassCard(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MainMetric(
            label: s.download,
            value: r.downloadMbps?.toStringAsFixed(1) ?? '—',
            unit: 'Mbps',
            color: context.netChui.accent,
          ),
          _MainMetric(
            label: s.upload,
            value: r.uploadMbps?.toStringAsFixed(1) ?? '—',
            unit: 'Mbps',
            color: AppColors.purple,
          ),
          _MainMetric(
            label: s.ping,
            value: r.pingMs?.round().toString() ?? '—',
            unit: 'ms',
            color: context.netChui.info,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required IconData icon, required List<Widget> children}) {
    final colors = context.netChui;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10, top: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: colors.text.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: children,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MainMetric extends StatelessWidget {
  const _MainMetric({required this.label, required this.value, required this.unit, required this.color});
  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: context.netChui.muted,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: -1.5,
            fontFamily: 'JetBrainsMono',
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: context.netChui.subtle,
          ),
        ),
      ],
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
    final colors = context.netChui;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.muted,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: colors.text,
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
