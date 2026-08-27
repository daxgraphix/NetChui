import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/glass_card.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;

    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppHeader(
              title: s.guidesTitle,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.netChui.text),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: Spacing.lg),
                  _GuideItem(
                    title: s.guide1Title,
                    body: s.guide1Body,
                    icon: Icons.speed_rounded,
                  ),
                  _GuideItem(
                    title: s.guide2Title,
                    body: s.guide2Body,
                    icon: Icons.wifi_rounded,
                  ),
                  _GuideItem(
                    title: s.guide3Title,
                    body: s.guide3Body,
                    icon: Icons.cell_tower_rounded,
                  ),
                  _GuideItem(
                    title: s.guide4Title,
                    body: s.guide4Body,
                    icon: Icons.build_circle_outlined,
                  ),
                  _GuideItem(
                    title: s.guide5Title,
                    body: s.guide5Body,
                    icon: Icons.security_rounded,
                  ),
                  _GuideItem(
                    title: s.guide6Title,
                    body: s.guide6Body,
                    icon: Icons.router_rounded,
                  ),
                  _GuideItem(
                    title: s.guide7Title,
                    body: s.guide7Body,
                    icon: Icons.insights_rounded,
                  ),
                  _GuideItem(
                    title: s.guide8Title,
                    body: s.guide8Body,
                    icon: Icons.vibration_rounded,
                  ),
                  _GuideItem(
                    title: s.guide9Title,
                    body: s.guide9Body,
                    icon: Icons.hub_rounded,
                  ),
                  _GuideItem(
                    title: s.guide10Title,
                    body: s.guide10Body,
                    icon: Icons.data_usage_rounded,
                  ),
                  _GuideItem(
                    title: s.guide11Title,
                    body: s.guide11Body,
                    icon: Icons.sports_esports_rounded,
                  ),
                  _GuideItem(
                    title: s.guide12Title,
                    body: s.guide12Body,
                    icon: Icons.business_center_rounded,
                  ),
                  _GuideItem(
                    title: s.guide13Title,
                    body: s.guide13Body,
                    icon: Icons.lan_rounded,
                  ),
                  _GuideItem(
                    title: s.guide14Title,
                    body: s.guide14Body,
                    icon: Icons.battery_charging_full_rounded,
                  ),
                  _GuideItem(
                    title: s.guide15Title,
                    body: s.guide15Body,
                    icon: Icons.auto_awesome_rounded,
                  ),
                  const SizedBox(height: 120),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  const _GuideItem({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: GlassCard(
        padding: EdgeInsets.zero,
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
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.lg, horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.netChui.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: context.netChui.accent.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Icon(icon, color: context.netChui.accent, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              body,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: context.netChui.text.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
