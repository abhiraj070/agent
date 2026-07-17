import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Small sub-progress indicator for a multi-part step nested inside a
/// single onboarding step — distinct from the main onboarding dot rail.
class MiniStepDots extends StatelessWidget {
  const MiniStepDots({
    super.key,
    required this.stepCount,
    required this.activeIndex,
  });

  final int stepCount;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(stepCount, (index) {
        final reached = index <= activeIndex;
        return Container(
          width: 16,
          height: 3,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: reached
                ? AppColors.green.withOpacity(0.8)
                : Colors.white.withOpacity(0.14),
          ),
        );
      }),
    );
  }
}
