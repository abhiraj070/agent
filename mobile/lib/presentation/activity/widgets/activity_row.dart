import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../domain/entities/activity_item.dart';

/// Ports `.activity-row`: a check glyph + time/title/meta stack. Tapping
/// opens the matching detail view (see ActivityScreen).
class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key, required this.item, required this.onTap});

  final ActivityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 27,
              height: 27,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.green.withOpacity(0.22)),
              ),
              child: const Text('✓', style: TextStyle(color: AppColors.green, fontSize: 10)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatActivityTimestamp(item.createdAt).toUpperCase(),
                    style: const TextStyle(color: AppColors.green, fontSize: 8, letterSpacing: 1),
                  ),
                  const SizedBox(height: 7),
                  Text(item.response, style: AppTextStyles.activityTitle, maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 7),
                  const Text('Handled by Aaraam', style: TextStyle(color: AppColors.faint, fontSize: 9)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('›', style: TextStyle(color: AppColors.faint, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
