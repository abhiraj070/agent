import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/activity_controller.dart';
import '../../application/screen_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/activity_row.dart';

/// Ports the `activity-screen` subscreen: chronological outcome history.
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activityControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(23, 8, 23, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => ref.read(currentScreenProvider.notifier).state = AppScreen.people,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.025),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: const Text('‹', style: TextStyle(color: AppColors.ink, fontSize: 22)),
                ),
              ),
              const SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QUIET HISTORY', style: AppTextStyles.eyebrow),
                  const SizedBox(height: 5),
                  Text('Activity', style: AppTextStyles.headline.copyWith(fontSize: 36)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 27),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Column(
              children: [for (final item in activity) ActivityRow(item: item)],
            ),
          ),
          const SizedBox(height: 27),
          const Text(
            'No recordings. No transcripts. Just enough to remember what was handled.',
            style: TextStyle(color: AppColors.faint, fontSize: 9, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
