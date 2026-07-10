import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/glass_card.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;

    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppHeader(
              title: s.privacyPolicy,
              expandedHeight: 120,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
                      child: GlassCard(
                        padding: const EdgeInsets.all(Spacing.xl),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.netChui.accent.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.verified_user_rounded,
                                  size: 40, color: context.netChui.accent),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              s.privacyPolicy,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 32),
                            _buildBullet(context, s.privacyBullet1),
                            _buildBullet(context, s.privacyBullet2),
                            _buildBullet(context, s.privacyBullet3),
                            _buildBullet(context, s.privacyBullet4),
                            _buildBullet(context, s.privacyBullet5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildBullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.netChui.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.check_rounded, size: 14, color: context.netChui.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: context.netChuiText.bodyLarge?.copyWith(
                height: 1.5,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: context.netChui.text.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
