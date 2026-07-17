import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/orbit_visual.dart';
import '../../../core/widgets/pill_button.dart';

/// Step 0 — ports the welcome screen with the "welcome-visual" orbit and the
/// "A little less to carry." headline.
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key, required this.onBegin});

  final VoidCallback onBegin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: OrbitVisual(
              size: 212,
              rings: const [
                OrbitRing(sizeFactor: 0.41, opacity: 0.32, rotationSeconds: 22),
                OrbitRing(sizeFactor: 0.69, opacity: 0.24, rotationSeconds: 34, reverse: true),
                OrbitRing(sizeFactor: 1.0, opacity: 0.1, rotationSeconds: 48),
              ],
              orbitingDotCount: 3,
              center: Container(
                width: 51,
                height: 51,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green.withOpacity(0.045),
                  border: Border.all(color: AppColors.green.withOpacity(0.26)),
                ),
                child: const Text('✦', style: TextStyle(color: AppColors.green, fontSize: 18)),
              ),
            ),
          ),
        ),
        const Text('A QUIETER WAY TO LIVE', style: AppTextStyles.eyebrow),
        const SizedBox(height: 13),
        const Text('A little less\nto carry.', style: AppTextStyles.headline),
        const SizedBox(height: 15),
        const Text(
          'The calls, follow-ups and tiny decisions can leave your mind now.',
          style: AppTextStyles.subline,
        ),
        const SizedBox(height: 25),
        PillButton(label: 'Begin', onPressed: onBegin),
        const SizedBox(height: 12),
        const Text(
          'Private by design. Yours from the start.',
          style: TextStyle(color: AppColors.faint, fontSize: 8),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
