import 'package:flutter/material.dart';
import '../../models/network_log.dart';
import '../../theme/app_theme.dart';
import '../insights_screen.dart'; // To access LogCard

class ActivityLogsTab extends StatelessWidget {
  final bool isLoading;
  final List<NetworkLog> toolLogs;
  final Widget emptyState;
  final Function(int) onDeleteLog;

  const ActivityLogsTab({
    super.key,
    required this.isLoading,
    required this.toolLogs,
    required this.emptyState,
    required this.onDeleteLog,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (toolLogs.isEmpty) return emptyState;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 100),
      itemCount: toolLogs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final log = toolLogs[i];
        return Dismissible(
          key: Key('log_${log.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
          ),
          onDismissed: (_) => onDeleteLog(log.id),
          child: LogCard(log: log, onDelete: () => onDeleteLog(log.id)),
        );
      },
    );
  }
}
