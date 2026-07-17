import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/account_setup_controller.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/mini_step_dots.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/selectable_chip.dart';
import '../../../data/local/seed_data.dart';

/// Third part of the account-setup sub-flow — the owner's preferred reply
/// language. Reuses the same chip-grid pattern as [RolePicker] since this
/// is a deliberate, one-time choice rather than a quick form field.
class ResponseLanguageStep extends ConsumerWidget {
  const ResponseLanguageStep({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountSetupControllerProvider);
    final controller = ref.read(accountSetupControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MiniStepDots(stepCount: 3, activeIndex: 2),
        const SizedBox(height: 16),
        const Text('ONE LAST THING', style: AppTextStyles.eyebrow),
        const SizedBox(height: 13),
        const Text('Which language should\nI reply in?', style: AppTextStyles.headline),
        const SizedBox(height: 15),
        const Text(
          'I’ll use this whenever I bring back an update for you.',
          style: AppTextStyles.subline,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 7,
              crossAxisSpacing: 7,
              childAspectRatio: 3.2,
              children: SeedData.languages.map((language) {
                return SelectableChip(
                  label: language,
                  selected: language == state.language,
                  onTap: () => controller.selectLanguage(language),
                );
              }).toList(),
            ),
          ),
        ),
        PillButton(
          label: 'Continue',
          onPressed: () async {
            await controller.confirmLanguage();
            onContinue();
          },
        ),
      ],
    );
  }
}
