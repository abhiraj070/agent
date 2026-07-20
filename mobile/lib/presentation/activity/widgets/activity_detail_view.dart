import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/person_avatar.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../data/remote/api_exception.dart';
import '../../../domain/entities/activity_item.dart';

/// A single Activity record — what was asked and what came back. Reuses
/// the same OUTCOME-card layout the live task-complete view uses, just
/// fed from history instead of the in-progress task state. Closing is
/// non-destructive (just returns to the list); deleting is a distinct,
/// confirmed action so browsing history can't accidentally erase it.
class ActivityDetailView extends StatelessWidget {
  const ActivityDetailView({
    super.key,
    required this.item,
    required this.onClose,
    required this.onDelete,
  });

  final ActivityItem item;
  final VoidCallback onClose;
  final Future<void> Function() onDelete;

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111514),
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Delete this outcome?', style: AppTextStyles.resultTitle.copyWith(fontSize: 17)),
              const SizedBox(height: 8),
              const Text('This can’t be undone.', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: PillButton(
                      label: 'Cancel',
                      variant: PillButtonVariant.ghost,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: PillButton(
                      label: 'Delete',
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await _confirmDelete(context);
    if (!confirmed) return;
    try {
      await onDelete();
      if (context.mounted) {
        onClose();
        AppToast.show(context, 'Removed from Activity');
      }
    } on ApiException catch (e) {
      if (context.mounted) AppToast.show(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(23, 8, 23, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onClose,
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
          const SizedBox(height: 24),
          const Text('OUTCOME', style: AppTextStyles.eyebrow, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          const Center(child: PersonAvatar(initials: '✓', size: 52)),
          const SizedBox(height: 16),
          Text(
            formatActivityDate(item.createdAt),
            style: const TextStyle(color: AppColors.faint, fontSize: 10),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (item.message.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                border: Border.all(color: AppColors.muted.withOpacity(0.16)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('YOU ASKED', style: TextStyle(color: AppColors.muted, fontSize: 8, letterSpacing: 0.5)),
                  const SizedBox(height: 5),
                  Text(
                    '“${item.message}”',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      color: Color(0xFFD6D9D7),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.fromLTRB(18, 19, 18, 17),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.025),
              border: Border.all(color: AppColors.green.withOpacity(0.18)),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Text(item.response, style: AppTextStyles.resultTitle),
          ),
          const SizedBox(height: 18),
          PillButton(label: 'Close', variant: PillButtonVariant.ghost, onPressed: onClose),
          const SizedBox(height: 14),
          Center(
            child: TextButton(
              onPressed: () => _handleDelete(context),
              child: const Text('Delete this', style: TextStyle(color: AppColors.errorSoft, fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }
}
