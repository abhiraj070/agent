import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/person_avatar.dart';

/// Ports `.result-card`: the completed-outcome summary shown once a task
/// finishes. `/chat` returns a single response with no per-contact
/// attribution, so this no longer tries to guess a source from the text.
class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 18),
      padding: const EdgeInsets.fromLTRB(18, 19, 18, 17),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.025),
        border: Border.all(color: AppColors.green.withOpacity(0.18)),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PersonAvatar(initials: '✓', size: 33),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'OUTCOME',
                    style: TextStyle(color: AppColors.green, fontSize: 8, letterSpacing: 1),
                  ),
                  SizedBox(height: 3),
                  Text('Just now', style: TextStyle(color: AppColors.faint, fontSize: 8)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(result, style: AppTextStyles.resultTitle),
          const SizedBox(height: 11),
          const Text(
            'Only this useful outcome is saved.',
            style: TextStyle(color: AppColors.faint, fontSize: 8),
          ),
        ],
      ),
    );
  }
}
