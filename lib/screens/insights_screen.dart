import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/network_log.dart';
import '../models/history_entry.dart';
import '../services/storage_service.dart';
import '../services/health_analysis_service.dart';
import '../services/report_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import 'insights/health_tab.dart';
import 'insights/performance_tab.dart';
import 'insights/signal_tab.dart';
import 'insights/activity_tab.dart';

import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/widgets/section_title.dart';
import 'package:net_chui/widgets/offline_overlay.dart';
import 'package:net_chui/widgets/base_modal.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key, this.isInternal = false});

  final bool isInternal;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NetworkLog> _signalHistory = [];
  List<NetworkLog> _toolLogs = [];
  List<HistoryEntry> _speedHistory = [];
  NetworkHealthAnalysis? _healthAnalysis;
  bool _isLoading = true;
  DateTime? _lastUpdated;
  int _selectedDays = 7;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final range = DateTime.now().subtract(Duration(days: _selectedDays));
    
    try {
      final results = await Future.wait([
        StorageService.instance.getSignalHistory(range),
        StorageService.instance.loadNetworkLogs(),
        StorageService.instance.loadHistory(),
        HealthAnalysisService().analyzeRecentHealth(),
      ]);

      final signals = results[0] as List<NetworkLog>;
      final logs = results[1] as List<NetworkLog>;
      final history = results[2] as List<HistoryEntry>;
      final health = results[3] as NetworkHealthAnalysis?;

      // Filter tool logs to exclude raw signals
      final toolLogs = logs.where((l) => l.type != 'SIGNAL').toList();

      setState(() {
        _signalHistory = signals;
        _toolLogs = toolLogs;
        _speedHistory = history;
        _healthAnalysis = health;
        _isLoading = false;
        _lastUpdated = DateTime.now();
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInternal) {
      if (_isLoading || _healthAnalysis == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return HealthTab(
        analysis: _healthAnalysis!,
        speedHistory: _speedHistory,
        isInternal: true,
      );
    }

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final s = state.strings;
        return Scaffold(
          body: GradientBackground(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(s.networkInsights,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white)),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [context.netChui.accent, context.netChui.accent.withValues(alpha: 0.6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 62),
                  ),
                  pinned: true,
                  backgroundColor: context.netChui.accent,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.download_rounded, color: Colors.white),
                      tooltip: s.exportAllData,
                      onPressed: () => ReportService.instance.exportAllData(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                      tooltip: 'Clear All Logs',
                      onPressed: () => _confirmClearLogs(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      onPressed: _loadData,
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      color: Colors.transparent,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        indicatorWeight: 3,
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        dividerColor: Colors.transparent,
                        unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                        tabs: [
                          Tab(text: s.health),
                          Tab(text: s.signalTrends),
                          Tab(text: s.insights),
                          Tab(text: s.activityLogs),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: Column(
                children: [
                  if (!state.isOnline)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.lg, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OfflineOverlay(onRetry: _loadData),
                          if (_lastUpdated != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 4),
                              child: Text(
                                'Last updated: ${DateFormat('HH:mm').format(_lastUpdated!)}',
                                style: TextStyle(fontSize: 10, color: context.netChui.muted),
                              ),
                            ),
                        ],
                      ),
                    ),
                  _buildDateFilters(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildHealthTab(),
                        _buildSignalTrendTab(),
                        _buildPerformanceTab(),
                        _buildActivityLogsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateFilters() {
    final s = AppState.instance.strings;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.lg, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [1, 7, 30].map((days) {
            final isSelected = _selectedDays == days;
            final label = days == 1 ? '24 ${s.time}' : '$days ${s.date}s';
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (val) {
                  if (val) {
                    setState(() => _selectedDays = days);
                    _loadData();
                  }
                },
                selectedColor: context.netChui.accent.withValues(alpha: 0.1),
                checkmarkColor: context.netChui.accent,
                side: BorderSide(
                  color: isSelected ? context.netChui.accent.withValues(alpha: 0.5) : context.netChui.border,
                  width: 1,
                ),
                backgroundColor: context.netChui.card.withValues(alpha: 0.05),
                labelStyle: TextStyle(
                  color: isSelected ? context.netChui.accent : context.netChui.text,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _confirmClearLogs() async {
    final s = AppState.instance.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.clearActivityLogs),
        content: Text(s.clearActivityLogsConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(s.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: context.netChui.accent),
            child: Text(s.deleteAll),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AppState.instance.clearNetworkLogs();
      _loadData();
    }
  }

  Future<void> _deleteLog(int id) async {
    await AppState.instance.deleteNetworkLog(id);
    _loadData();
  }

  Widget _buildHealthTab() {
    if (_isLoading || _healthAnalysis == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return HealthTab(
      analysis: _healthAnalysis!,
      speedHistory: _speedHistory,
    );
  }

  Widget _buildPerformanceTab() {
    final s = AppState.instance.strings;
    return PerformanceTab(
      isLoading: _isLoading,
      speedHistory: _speedHistory,
      emptyState: EmptyState(
        icon: Icons.speed_outlined,
        title: s.noSpeedHistory,
        message: s.performanceEmptyState,
      ),
    );
  }

  Widget _buildSignalTrendTab() {
    final s = AppState.instance.strings;
    return SignalTrendTab(
      isLoading: _isLoading,
      signalHistory: _signalHistory,
      emptyState: EmptyState(
        icon: Icons.cell_tower_rounded,
        title: s.noSignalHistory,
        message: s.signalEmptyState,
      ),
    );
  }

  Widget _buildActivityLogsTab() {
    final s = AppState.instance.strings;
    return ActivityLogsTab(
      isLoading: _isLoading,
      toolLogs: _toolLogs,
      onDeleteLog: _deleteLog,
      emptyState: EmptyState(
        icon: Icons.history_rounded,
        title: s.noToolActivity,
        message: s.activityEmptyState,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({required this.icon, required this.title, required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.netChui.card.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: context.netChui.border.withValues(alpha: 0.2)),
              ),
              child: Icon(icon, size: 48, color: context.netChui.muted.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(color: context.netChui.muted, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


class LogCard extends StatelessWidget {
  const LogCard({required this.log, required this.onDelete, super.key});
  final NetworkLog log;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    final IconData icon = switch (log.type) {
      'DIAGNOSTICS_DNS' || 'DNS_BENCHMARK' => Icons.dns_rounded,
      'DIAGNOSTICS_PORTSCAN' => Icons.security_rounded,
      'DIAGNOSTICS_WHOIS' => Icons.info_outline_rounded,
      'SCAN' => Icons.radar_rounded,
      'LAN_SCAN' => Icons.devices_other_rounded,
      'RECOMMENDATION' => Icons.tips_and_updates_outlined,
      'SIGNAL' => Icons.signal_cellular_alt_rounded,
      _ => Icons.article_rounded,
    };

    return GlassCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: Spacing.md),
      onTap: () => _showLogDetails(context),
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
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: context.netChui.accent.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: context.netChui.accent, size: 20),
                ),
                title: Text(log.title ?? s.networkActivity, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: -0.3)),
                subtitle: Text(log.subtitle ?? '', style: TextStyle(color: context.netChui.muted, fontSize: 12, fontWeight: FontWeight.w500)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(DateFormat('MMM d').format(log.timestamp), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, fontFamily: 'JetBrainsMono')),
                    Text(DateFormat('HH:mm').format(log.timestamp), style: TextStyle(fontSize: 10, color: context.netChui.muted, fontWeight: FontWeight.w700, fontFamily: 'JetBrainsMono')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _LogDetailModal(log: log, onDelete: onDelete),
    );
  }
}

class _LogDetailModal extends StatefulWidget {
  const _LogDetailModal({required this.log, required this.onDelete});
  final NetworkLog log;
  final VoidCallback onDelete;

  @override
  State<_LogDetailModal> createState() => _LogDetailModalState();
}

class _LogDetailModalState extends State<_LogDetailModal> {
  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;
    Map<String, dynamic> data = {};
    if (widget.log.rawData != null) {
      try {
        data = jsonDecode(widget.log.rawData!);
      } catch (_) {}
    }

    final IconData icon = switch (widget.log.type) {
      'DIAGNOSTICS_DNS' || 'DNS_BENCHMARK' => Icons.dns_rounded,
      'DIAGNOSTICS_PORTSCAN' => Icons.security_rounded,
      'DIAGNOSTICS_WHOIS' => Icons.info_outline_rounded,
      'SCAN' => Icons.radar_rounded,
      'LAN_SCAN' => Icons.devices_other_rounded,
      'RECOMMENDATION' => Icons.tips_and_updates_outlined,
      'SIGNAL' => Icons.signal_cellular_alt_rounded,
      _ => Icons.article_rounded,
    };

    return BaseModal(
      title: widget.log.title ?? s.logDetails,
      icon: icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM d, yyyy - HH:mm:ss').format(widget.log.timestamp),
                style: TextStyle(color: context.netChui.muted, fontSize: 13),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onDelete();
                },
                icon: Icon(Icons.delete_outline_rounded, color: context.netChui.accent),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (widget.log.recommendation != null) ...[
            SectionTitle(s.recommendations),
            const SizedBox(height: 12),
            GlassCard(
              padding: EdgeInsets.zero,
              color: AppColors.green,
              opacity: 0.1,
              borderColor: AppColors.green,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(2)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline_rounded, color: AppColors.green, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.log.recommendation!,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          SectionTitle(s.technicalData),
          const SizedBox(height: 12),
          if (data.isNotEmpty)
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: data.entries.map((e) {
                  if (e.value is Map || e.value is List) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            e.key.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: context.netChui.muted,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.netChui.glass,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.netChui.border.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            const JsonEncoder.withIndent('  ').convert(e.value),
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }
                  return ModalRow(label: e.key, value: e.value.toString(), isMono: true);
                }).toList(),
              ),
            )
          else
            GlassCard(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.log.rawData ?? 'No data',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Copy logic
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: Text(s.copyResult),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ReportService.instance.shareDiagnosticLog(
                      widget.log.title ?? 'Log',
                      widget.log.type,
                      widget.log.subtitle ?? '',
                      data,
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: Text(s.share),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

