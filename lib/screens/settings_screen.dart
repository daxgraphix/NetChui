import 'package:flutter/material.dart' hide RadioGroup;
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/models/speed_test_server.dart';
import 'package:net_chui/models/test_mode.dart';
import 'package:net_chui/models/test_size.dart';
import 'package:net_chui/screens/history_screen.dart';
import 'package:net_chui/screens/report_screen.dart';
import 'package:net_chui/screens/privacy_screen.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/radio_group.dart';
import 'package:net_chui/widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final s = state.strings;
        final settings = state.settings;

        return Scaffold(
          body: GradientBackground(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
            AppHeader(
              title: s.settings,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.netChui.text),
                onPressed: () => Navigator.pop(context),
              ),
            ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Spacing.lg),
                            _SectionTitle(s.theme.toUpperCase()),
                            const SizedBox(height: Spacing.sm),
                            GlassCard(
                              padding: const EdgeInsets.all(Spacing.md),
                              child: SegmentedButton<ThemeMode>(
                                showSelectedIcon: false,
                                style: SegmentedButton.styleFrom(
                                  selectedBackgroundColor: context.netChui.accent,
                                  selectedForegroundColor: Colors.white,
                                  side: BorderSide.none,
                                  backgroundColor: Colors.transparent,
                                ),
                                segments: [
                                  ButtonSegment(
                                    value: ThemeMode.system,
                                    icon: const Icon(Icons.brightness_auto_rounded, size: 20),
                                    label: Text(s.themeSystem, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ),
                                  ButtonSegment(
                                    value: ThemeMode.dark,
                                    icon: const Icon(Icons.dark_mode_rounded, size: 20),
                                    label: Text(s.themeDark, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ),
                                  ButtonSegment(
                                    value: ThemeMode.light,
                                    icon: const Icon(Icons.light_mode_rounded, size: 20),
                                    label: Text(s.themeLight, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                                selected: {settings.themeMode},
                                onSelectionChanged: (v) => state.updateSettings(
                                  settings.copyWith(themeMode: v.first),
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xl),
                            _SectionTitle(s.server.toUpperCase()),
                            const SizedBox(height: Spacing.sm),
                            GlassCard(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                title: Text(s.server),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      SpeedTestServer.byId(settings.serverId).name,
                                      style: TextStyle(
                                        color: context.netChui.accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right_rounded, size: 20),
                                  ],
                                ),
                                onTap: () => _showServerPicker(context, state),
                              ),
                            ),
                            const SizedBox(height: Spacing.xl),
                            _SectionTitle(s.testSize.toUpperCase()),
                            const SizedBox(height: Spacing.xs),
                            GlassCard(
                              padding: EdgeInsets.zero,
                              child: RadioGroup<TestSize>(
                                value: settings.testSize,
                                onChanged: (v) {
                                  if (v != null) {
                                    state.updateSettings(settings.copyWith(testSize: v));
                                  }
                                },
                                child: Column(
                                  children: TestSize.values.map((size) {
                                    return RadioGroupItem<TestSize>(
                                      title: Text(size.label(context)),
                                      value: size,
                                      fillColor: WidgetStateProperty.all(context.netChui.accent),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            _SectionTitle(s.testMode.toUpperCase()),
                            const SizedBox(height: Spacing.xs),
                            GlassCard(
                              padding: EdgeInsets.zero,
                              child: RadioGroup<TestMode>(
                                value: settings.testMode,
                                onChanged: (v) {
                                  if (v != null) {
                                    state.updateSettings(settings.copyWith(testMode: v));
                                  }
                                },
                                child: Column(
                                  children: TestMode.values.map((mode) {
                                    return RadioGroupItem<TestMode>(
                                      title: Text(mode.label(context)),
                                      value: mode,
                                      fillColor: WidgetStateProperty.all(context.netChui.accent),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xl),
                            _SectionTitle(s.activityLogs.toUpperCase()),
                            const SizedBox(height: Spacing.sm),
                            GlassCard(
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.history_rounded),
                                    title: Text(s.history),
                                    trailing: const Icon(Icons.chevron_right_rounded),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                                    ),
                                  ),
                                  Divider(indent: 56, color: context.netChui.border),
                                  ListTile(
                                    leading: const Icon(Icons.analytics_outlined),
                                    title: Text(s.report),
                                    trailing: const Icon(Icons.chevron_right_rounded),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const ReportScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            GlassCard(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                leading: Icon(Icons.delete_sweep_outlined, color: context.netChui.accent),
                                title: Text(s.clearHistory, style: const TextStyle(fontWeight: FontWeight.w600)),
                                onTap: () async {
                                  final confirmed = await showDialog<bool>(
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
                                  if (confirmed == true) {
                                    await state.clearHistory();
                                    await state.clearNetworkLogs();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(s.allHistoryCleared)),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            GlassCard(
                              padding: EdgeInsets.zero,
                              child: SwitchListTile(
                                title: Text(s.dailyReminder, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(s.reminderTime),
                                activeTrackColor: context.netChui.accent,
                                value: settings.dailyReminderEnabled,
                                onChanged: (on) async {
                                  if (on) {
                                    final granted = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(s.dailyReminder),
                                        content: Text(s.notificationPermissionBody),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, false),
                                            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
                                          ),
                                          FilledButton(
                                            onPressed: () => Navigator.pop(ctx, true),
                                            child: Text(s.allow),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (granted != true) return;
                                  }
                                  await state.updateSettings(
                                    settings.copyWith(dailyReminderEnabled: on),
                                  );
                                },
                              ),
                            ),
                            if (settings.dailyReminderEnabled)
                              Padding(
                                padding: const EdgeInsets.only(top: Spacing.md),
                                child: GlassCard(
                                  padding: EdgeInsets.zero,
                                  child: ListTile(
                                    title: Text(s.reminderTime),
                                    trailing: Text(
                                      '${settings.reminderHour.toString().padLeft(2, '0')}:${settings.reminderMinute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    onTap: () async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: settings.reminderHour,
                                          minute: settings.reminderMinute,
                                        ),
                                      );
                                      if (time != null) {
                                        await state.updateSettings(
                                          settings.copyWith(
                                            reminderHour: time.hour,
                                            reminderMinute: time.minute,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            const SizedBox(height: Spacing.lg),
                            GlassCard(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                leading: const Icon(Icons.privacy_tip_outlined),
                                title: Text(s.privacy),
                                trailing: const Icon(Icons.chevron_right_rounded),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const PrivacyScreen(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 120),
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
      },
    );
  }

  void _showServerPicker(BuildContext context, AppState state) {
    final s = state.strings;
    final currentId = state.settings.serverId;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.netChui.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.netChui.text.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.xl),
              child: Text(
                s.server,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: SpeedTestServer.all.length,
                itemBuilder: (context, i) {
                  final srv = SpeedTestServer.all[i];
                  final isSelected = srv.id == currentId;
                  return ListTile(
                    onTap: () {
                      state.updateSettings(state.settings.copyWith(serverId: srv.id));
                      Navigator.pop(context);
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isSelected ? context.netChui.accent : context.netChui.text)
                            .withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.dns_rounded,
                        color: isSelected ? context.netChui.accent : context.netChui.text.withValues(alpha: 0.3),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      srv.name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? context.netChui.accent : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.radio_button_checked_rounded, color: context.netChui.accent)
                        : const Icon(Icons.radio_button_off_rounded),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
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
            text,
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
}
