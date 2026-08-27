import 'package:flutter/material.dart' hide RadioGroup;
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/models/speed_test_server.dart';
import 'package:net_chui/models/test_mode.dart';
import 'package:net_chui/models/test_size.dart';
import 'package:net_chui/screens/history_screen.dart';
import 'package:net_chui/screens/report_screen.dart';
import 'package:net_chui/screens/privacy_screen.dart';
import 'package:net_chui/screens/faq_screen.dart';
import 'package:net_chui/screens/guides_screen.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/radio_group.dart';
import 'package:net_chui/widgets/section_title.dart';
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
                            SectionTitle(s.theme),
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
                            SectionTitle(s.server),
                            const SizedBox(height: Spacing.sm),
                            _SettingsTile(
                              icon: Icons.dns_rounded,
                              title: s.server,
                              trailing: Text(
                                SpeedTestServer.byId(settings.serverId).name,
                                style: TextStyle(
                                  color: context.netChui.accent,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 13,
                                ),
                              ),
                              onTap: () => _showServerPicker(context, state),
                              accentColor: context.netChui.accent,
                            ),
                            const SizedBox(height: Spacing.xl),
                            SectionTitle(s.testSize),
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
                            SectionTitle(s.testMode),
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
                            SectionTitle(s.activityLogs),
                            const SizedBox(height: Spacing.sm),
                            _SettingsTile(
                              icon: Icons.history_rounded,
                              title: s.history,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const HistoryScreen()),
                              ),
                              accentColor: context.netChui.accent,
                            ),
                            const SizedBox(height: Spacing.md),
                            _SettingsTile(
                              icon: Icons.analytics_outlined,
                              title: s.report,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ReportScreen()),
                              ),
                              accentColor: context.netChui.info,
                            ),
                            const SizedBox(height: Spacing.xl),
                            SectionTitle(s.dataManagement),
                            const SizedBox(height: Spacing.sm),
                            _SettingsTile(
                              icon: Icons.delete_sweep_outlined,
                              title: s.clearHistory,
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
                              accentColor: context.netChui.accent,
                            ),
                            const SizedBox(height: Spacing.xl),
                            SectionTitle(s.notifications),
                            const SizedBox(height: Spacing.sm),
                            GlassCard(
                              padding: EdgeInsets.zero,
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      color: context.netChui.accent,
                                    ),
                                    Expanded(
                                      child: SwitchListTile(
                                        title: Text(s.dailyReminder, 
                                          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                                        subtitle: Text(s.reminderTime, style: TextStyle(color: context.netChui.muted)),
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
                                  ],
                                ),
                              ),
                            ),
                            if (settings.dailyReminderEnabled)
                              Padding(
                                padding: const EdgeInsets.only(top: Spacing.md),
                                child: _SettingsTile(
                                  icon: Icons.access_time_rounded,
                                  title: s.reminderTime,
                                  trailing: Text(
                                    '${settings.reminderHour.toString().padLeft(2, '0')}:${settings.reminderMinute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontFamily: 'JetBrainsMono'),
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
                                  accentColor: context.netChui.accent,
                                ),
                              ),
                            const SizedBox(height: Spacing.xl),
                            SectionTitle(s.support),
                            const SizedBox(height: Spacing.sm),
                            _SettingsTile(
                              icon: Icons.privacy_tip_outlined,
                              title: s.privacy,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const PrivacyScreen(),
                                ),
                              ),
                              accentColor: context.netChui.secondary,
                            ),
                            const SizedBox(height: Spacing.md),
                            _SettingsTile(
                              icon: Icons.help_outline_rounded,
                              title: s.faq,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const FaqScreen(),
                                ),
                              ),
                              accentColor: context.netChui.tertiary,
                            ),
                            const SizedBox(height: Spacing.md),
                            _SettingsTile(
                              icon: Icons.menu_book_rounded,
                              title: s.appGuides,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const GuidesScreen(),
                                ),
                              ),
                              accentColor: context.netChui.success,
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.accentColor,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color accentColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 16),
            ] else ...[
              Icon(Icons.chevron_right_rounded, size: 20, color: context.netChui.subtle),
              const SizedBox(width: 16),
            ],
          ],
        ),
      ),
    );
  }
}
