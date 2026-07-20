import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/activity_controller.dart';
import '../../application/screen_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/activity_detail_view.dart';
import 'widgets/activity_row.dart';

/// Ports the `activity-screen` subscreen: chronological outcome history,
/// backend-first (see ActivityController). Toggles between the list and
/// a single record's detail view via [selectedActivityIdProvider].
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activityControllerProvider);
    final selectedId = ref.watch(selectedActivityIdProvider);

    if (selectedId != null) {
      final matches = activity.where((a) => a.id == selectedId);
      if (matches.isNotEmpty) {
        return ActivityDetailView(
          item: matches.first,
          onClose: () => ref.read(selectedActivityIdProvider.notifier).state = null,
          onDelete: () => ref.read(activityControllerProvider.notifier).delete(selectedId),
        );
      }
      // Item no longer in the list (e.g. cache refreshed under it) — fall
      // back to the list instead of showing a blank detail view. Deferred
      // to after this frame: writing to a provider this widget is
      // currently watching, synchronously during build, throws.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ref.read(selectedActivityIdProvider.notifier).state = null;
        }
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(23, 8, 23, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  ref.read(selectedActivityIdProvider.notifier).state = null;
                  ref.read(currentScreenProvider.notifier).state = AppScreen.home;
                },
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
          if (activity.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Nothing yet — completed requests will show up here.',
                style: TextStyle(color: AppColors.faint, fontSize: 11, height: 1.6),
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Column(
                children: [
                  for (final item in activity)
                    ActivityRow(
                      item: item,
                      onTap: () => ref.read(selectedActivityIdProvider.notifier).state = item.id,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 27),
            const Text(
              'No recordings. No transcripts. Just enough to remember what was handled.',
              style: TextStyle(color: AppColors.faint, fontSize: 9, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
