import 'package:flutter/material.dart';
import 'package:net_chui/app/app_state.dart';
import 'package:net_chui/theme/app_theme.dart';
import 'package:net_chui/widgets/app_header.dart';
import 'package:net_chui/widgets/gradient_background.dart';
import 'package:net_chui/widgets/glass_card.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance.strings;

    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppHeader(
              title: s.faqTitle,
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
                  _FaqItem(question: s.faqQ1, answer: s.faqA1),
                  _FaqItem(question: s.faqQ2, answer: s.faqA2),
                  _FaqItem(question: s.faqQ3, answer: s.faqA3),
                  _FaqItem(question: s.faqQ4, answer: s.faqA4),
                  _FaqItem(question: s.faqQ5, answer: s.faqA5),
                  _FaqItem(question: s.faqQ6, answer: s.faqA6),
                  _FaqItem(question: s.faqQ7, answer: s.faqA7),
                  _FaqItem(question: s.faqQ8, answer: s.faqA8),
                  _FaqItem(question: s.faqQ9, answer: s.faqA9),
                  _FaqItem(question: s.faqQ10, answer: s.faqA10),
                  _FaqItem(question: s.faqQ11, answer: s.faqA11),
                  _FaqItem(question: s.faqQ12, answer: s.faqA12),
                  _FaqItem(question: s.faqQ13, answer: s.faqA13),
                  _FaqItem(question: s.faqQ14, answer: s.faqA14),
                  _FaqItem(question: s.faqQ15, answer: s.faqA15),
                  _FaqItem(question: s.faqQ16, answer: s.faqA16),
                  _FaqItem(question: s.faqQ17, answer: s.faqA17),
                  _FaqItem(question: s.faqQ18, answer: s.faqA18),
                  _FaqItem(question: s.faqQ19, answer: s.faqA19),
                  _FaqItem(question: s.faqQ20, answer: s.faqA20),
                  _FaqItem(question: s.faqQ21, answer: s.faqA21),
                  _FaqItem(question: s.faqQ22, answer: s.faqA22),
                  _FaqItem(question: s.faqQ23, answer: s.faqA23),
                  _FaqItem(question: s.faqQ24, answer: s.faqA24),
                  _FaqItem(question: s.faqQ25, answer: s.faqA25),
                  _FaqItem(question: s.faqQ26, answer: s.faqA26),
                  _FaqItem(question: s.faqQ27, answer: s.faqA27),
                  _FaqItem(question: s.faqQ28, answer: s.faqA28),
                  _FaqItem(question: s.faqQ29, answer: s.faqA29),
                  _FaqItem(question: s.faqQ30, answer: s.faqA30),
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

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});
  final String question;
  final String answer;

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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        answer,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
