import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/activity_item.dart';

/// Ports `.activity-row`: a check glyph + time/title/meta stack.
class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key, required this.item});

  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  item.time.toUpperCase(),
                  style: const TextStyle(color: AppColors.green, fontSize: 8, letterSpacing: 1),
                ),
                const SizedBox(height: 7),
                Text(item.title, style: AppTextStyles.activityTitle),
                const SizedBox(height: 7),
                Text(item.meta, style: const TextStyle(color: AppColors.faint, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
