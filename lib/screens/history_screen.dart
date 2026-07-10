import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/l10n/app_localizations.dart';
import 'package:net_chui/models/history_entry.dart';
import 'package:net_chui/screens/history_detail_screen.dart';
import 'package:net_chui/services/haptic_service.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/glass_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final s = state.strings;
    final entries = state.history;
    final colors = context.netChui;

    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppHeader(
              title: s.history,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (entries.isNotEmpty)
                  IconButton(
                    onLongPress: () => state.seedHistory(500),
                    onPressed: () => _showClearDialog(context, state, s),
                    icon: const Icon(Icons.delete_sweep_rounded),
                    tooltip: s.clearHistory,
                  ),
              ],
            ),
            if (entries.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(context, s),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final entry = entries[i];
                      final bool isNewDay = i == 0 || 
                          DateFormat.yMd().format(entry.timestamp) != DateFormat.yMd().format(entries[i - 1].timestamp);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isNewDay) ...[
                            const SizedBox(height: Spacing.xl),
                            _SectionTitle(DateFormat.yMMMMd().format(entry.timestamp).toUpperCase()),
                            const SizedBox(height: Spacing.md),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(bottom: Spacing.md),
                            child: Dismissible(
                              key: Key(entry.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => state.deleteHistoryEntry(entry.id),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: colors.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Icon(Icons.delete_outline_rounded, color: colors.accent),
                              ),
                              child: _HistoryTile(entry: entry),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: entries.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: context.netChui.surface.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_toggle_off_rounded,
              size: 64,
              color: context.netChui.text.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            s.noHistory,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.netChui.text.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDialog(BuildContext context, AppState state, AppLocalizations s) async {
    HapticService.medium();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.clearHistory),
        content: Text(s.clearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: context.netChui.accent),
            child: Text(s.confirm),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await state.clearHistory();
      HapticService.light();
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: context.netChui.muted,
          ),
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final r = entry.result;
    final colors = context.netChui;
    final isWifi = entry.connectionType.toLowerCase().contains('wifi');

    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HistoryDetailScreen(entry: entry),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: (isWifi ? AppColors.secondary : AppColors.warning).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isWifi ? Icons.wifi_rounded : Icons.signal_cellular_alt_rounded,
                size: 20,
                color: isWifi ? AppColors.secondary : AppColors.warning,
              ),
            ),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat.jm().format(entry.timestamp),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colors.text,
                              fontFamily: 'JetBrainsMono',
                            ),
                      ),
                      const SizedBox(width: 8),
                      if (r.isp != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            r.isp!.split(' ').first.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: colors.accent,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _CompactMetric(
                        value: r.downloadMbps?.toStringAsFixed(1) ?? '—',
                        unit: 'Mb/s',
                        color: colors.accent,
                      ),
                      const SizedBox(width: 12),
                      _CompactMetric(
                        value: r.uploadMbps?.toStringAsFixed(1) ?? '—',
                        unit: 'Mb/s',
                        color: AppColors.purple,
                      ),
                      const SizedBox(width: 12),
                      _CompactMetric(
                        value: r.pingMs?.round().toString() ?? '—',
                        unit: 'ms',
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colors.subtle),
          ],
        ),
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({required this.value, required this.unit, required this.color});
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            fontFamily: 'JetBrainsMono',
            color: color,
          ),
        ),
        const SizedBox(width: 1),
        Text(
          unit,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: context.netChui.muted,
          ),
        ),
      ],
    );
  }
}
