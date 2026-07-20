import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The "⌁ Activity" entry-point row — shared by the People screen and
/// the Home idle screen so both link into Activity with the same look.
class ActivityLinkCard extends StatelessWidget {
  const ActivityLinkCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.025),
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Text('⌁', style: TextStyle(color: AppColors.green, fontSize: 16)),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Activity', style: TextStyle(color: AppColors.ink, fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    'Minimal outcomes, nothing more',
                    style: TextStyle(color: AppColors.muted, fontSize: 9),
                  ),
                ],
              ),
            ),
            const Text('›', style: TextStyle(color: AppColors.faint, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
