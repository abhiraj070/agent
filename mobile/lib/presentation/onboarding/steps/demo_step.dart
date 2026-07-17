import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/person_avatar.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../data/local/seed_data.dart';

/// Step 1 — ports the rotating request/result demo carousel.
class DemoStep extends StatelessWidget {
  const DemoStep({
    super.key,
    required this.exampleIndex,
    required this.onBack,
    required this.onContinue,
  });

  final int exampleIndex;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final example = SeedData.onboardingExamples[exampleIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text('ONE THOUGHT IN', style: AppTextStyles.eyebrow, textAlign: TextAlign.center),
        const SizedBox(height: 13),
        const Text(
          'Say it once.\nThen let it go.',
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        const Text(
          'Aaraam understands the people, sequence and follow-up—then brings back only what matters.',
          style: AppTextStyles.subline,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Column(
                key: ValueKey(exampleIndex),
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DemoBubble(
                    leading: const _MiniWave(),
                    child: Text(
                      example.request,
                      style: const TextStyle(fontFamily: 'serif', color: AppColors.ink, fontSize: 14),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 43,
                    color: AppColors.green.withOpacity(0.22),
                  ),
                  _DemoBubble(
                    tinted: true,
                    leading: PersonAvatar(initials: example.initials, size: 31),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          example.source.toUpperCase(),
                          style: const TextStyle(color: AppColors.green, fontSize: 7, letterSpacing: 1),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          example.result,
                          style: const TextStyle(fontFamily: 'serif', color: AppColors.ink, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(SeedData.onboardingExamples.length, (i) {
                      return Container(
                        width: 22,
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 3.5),
                        color: i == exampleIndex
                            ? AppColors.green.withOpacity(0.65)
                            : Colors.white.withOpacity(0.1),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            PillButton(label: 'Back', variant: PillButtonVariant.ghost, expand: false, onPressed: onBack),
            const SizedBox(width: 9),
            Expanded(child: PillButton(label: 'Continue', onPressed: onContinue)),
          ],
        ),
      ],
    );
  }
}

class _DemoBubble extends StatelessWidget {
  const _DemoBubble({required this.leading, required this.child, this.tinted = false});

  final Widget leading;
  final Widget child;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      constraints: const BoxConstraints(minHeight: 68),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: tinted ? AppColors.green.withOpacity(0.045) : Colors.white.withOpacity(0.025),
        border: Border.all(
          color: tinted ? AppColors.green.withOpacity(0.16) : Colors.white.withOpacity(0.075),
        ),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _MiniWave extends StatelessWidget {
  const _MiniWave();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 31,
      height: 31,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.green.withOpacity(0.06),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 1, height: 6, color: AppColors.green, margin: const EdgeInsets.symmetric(horizontal: 1)),
          Container(width: 1, height: 11, color: AppColors.green, margin: const EdgeInsets.symmetric(horizontal: 1)),
        ],
      ),
    );
  }
}
