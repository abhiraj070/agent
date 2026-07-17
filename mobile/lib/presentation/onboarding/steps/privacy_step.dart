import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/orbit_visual.dart';
import '../../../core/widgets/pill_button.dart';

/// Step 2 — ports the "No account access. Ever." privacy screen with its
/// floating "not connected" pills.
class PrivacyStep extends StatelessWidget {
  const PrivacyStep({super.key, required this.onBack, required this.onContinue});

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('NOTHING TO CONNECT', style: AppTextStyles.eyebrow),
        const SizedBox(height: 13),
        const Text('No account\naccess. Ever.', style: AppTextStyles.headline),
        const SizedBox(height: 15),
        const Text(
          'No contacts, WhatsApp, email or calendar. Aaraam knows only the people you choose to add.',
          style: AppTextStyles.subline,
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  OrbitVisual(
                    size: 224,
                    glowColor: AppColors.greenStrong,
                    rings: const [
                      OrbitRing(sizeFactor: 0.65, opacity: 0.22, rotationSeconds: 28),
                      OrbitRing(sizeFactor: 1.0, opacity: 0.08, rotationSeconds: 44, reverse: true),
                    ],
                    center: Container(
                      width: 98,
                      height: 98,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green.withOpacity(0.05),
                        border: Border.all(color: AppColors.green.withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.green.withOpacity(0.24)),
                            ),
                            child: const Text('✓', style: TextStyle(color: AppColors.green, fontSize: 8)),
                          ),
                          const Text(
                            'Only what\nyou add',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'serif', color: AppColors.ink, fontSize: 13, height: 1.15),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'NOTHING ELSE',
                            style: TextStyle(color: AppColors.faint, fontSize: 6, letterSpacing: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(left: 0, top: 30, child: _AccessPill(label: 'Contacts')),
                  const Positioned(right: -2, top: 74, child: _AccessPill(label: 'WhatsApp')),
                  const Positioned(left: 30, bottom: 20, child: _AccessPill(label: 'Email')),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('◇', style: TextStyle(color: AppColors.green.withOpacity(0.6), fontSize: 9)),
            const SizedBox(width: 5),
            const Text(
              'No imports · No recordings · No transcripts',
              style: TextStyle(color: AppColors.faint, fontSize: 7),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            PillButton(label: 'Back', variant: PillButtonVariant.ghost, expand: false, onPressed: onBack),
            const SizedBox(width: 9),
            Expanded(child: PillButton(label: 'Continue without connecting', onPressed: onContinue)),
          ],
        ),
      ],
    );
  }
}

class _AccessPill extends StatelessWidget {
  const _AccessPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 83),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xC20C100E),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: AppColors.ink.withOpacity(0.66), fontSize: 9)),
          const SizedBox(height: 3),
          Text(
            'Not connected',
            style: TextStyle(color: AppColors.faint.withOpacity(0.7), fontSize: 6, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}
