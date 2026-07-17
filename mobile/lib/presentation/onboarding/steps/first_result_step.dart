import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/orbit_visual.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../domain/entities/person.dart';

/// Step 5 — ports the "Reaching {name}" → "It's done." result screen.
class FirstResultStep extends StatelessWidget {
  const FirstResultStep({
    super.key,
    required this.person,
    required this.instruction,
    required this.done,
    required this.outcome,
    required this.onComplete,
  });

  final Person person;
  final String instruction;
  final bool done;
  final String outcome;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: OrbitVisual(
              size: 186,
              rings: const [
                OrbitRing(sizeFactor: 0.6, opacity: 0.35, rotationSeconds: 18),
                OrbitRing(sizeFactor: 1.0, opacity: 0.06, rotationSeconds: 32, reverse: true),
              ],
              center: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.green.withOpacity(0.9) : AppColors.green.withOpacity(0.07),
                  border: Border.all(color: AppColors.green.withOpacity(0.28)),
                ),
                child: Text(
                  done ? '✓' : person.initials,
                  style: TextStyle(
                    color: done ? const Color(0xFF102018) : AppColors.green,
                    fontSize: done ? 20 : 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          done ? 'FIRST TASK COMPLETE' : 'REACHING ${person.name.toUpperCase()}',
          style: AppTextStyles.eyebrow,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 13),
        Text(
          done ? 'It’s done.\nJust like that.' : 'You can let\nthis one go.',
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Text(
          done ? outcome : 'Aaraam is taking care of “$instruction”',
          style: AppTextStyles.subline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
        if (done) ...[
          PillButton(label: 'Now keep using Aaraam', onPressed: onComplete),
          const SizedBox(height: 12),
          const Text(
            'Your people and this outcome stay on this device.',
            style: TextStyle(color: AppColors.faint, fontSize: 8),
            textAlign: TextAlign.center,
          ),
        ] else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.green),
              ),
              const SizedBox(width: 8),
              Text(
                'Calling in ${person.language}',
                style: const TextStyle(color: AppColors.muted, fontSize: 9),
              ),
            ],
          ),
      ],
    );
  }
}
