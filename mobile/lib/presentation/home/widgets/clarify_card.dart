import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Ports `.clarify-card`: a one-detail follow-up prompt (e.g. "When should
/// the electrician come?") with a single canned reply.
class ClarifyCard extends StatelessWidget {
  const ClarifyCard({super.key, required this.onSend});

  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.025),
            border: Border.all(color: AppColors.green.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(suggestionText, style: TextStyle(color: AppColors.muted, fontSize: 12)),
              ElevatedButton(
                onPressed: () => onSend(suggestionText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: const Color(0xFF102018),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Send', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'I’ll only ask when one detail is truly needed.',
          style: TextStyle(color: AppColors.faint, fontSize: 9),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static const suggestionText = 'Sunday afternoon';
}
