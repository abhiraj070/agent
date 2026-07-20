import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/account_setup_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/bottom_sheet_shell.dart';
import '../../../core/widgets/country_picker_sheet.dart';
import '../../../core/widgets/mini_step_dots.dart';
import '../../../core/widgets/pill_button.dart';

/// First part of the account-setup sub-flow — phone number + country.
class PhoneEntryStep extends ConsumerWidget {
  const PhoneEntryStep({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountSetupControllerProvider);
    final controller = ref.read(accountSetupControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MiniStepDots(stepCount: 3, activeIndex: 0),
        const SizedBox(height: 16),
        const Text('YOUR NUMBER', style: AppTextStyles.eyebrow),
        const SizedBox(height: 13),
        const Text('What’s the best\nnumber to reach you?', style: AppTextStyles.headline),
        const SizedBox(height: 15),
        const Text(
          'We’ll text a one-time code to confirm it’s you.',
          style: AppTextStyles.subline,
        ),
        const Spacer(),
        const Text('Phone number', style: TextStyle(color: AppColors.muted, fontSize: 9)),
        const SizedBox(height: 7),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => BottomSheetShell.show(
                context,
                child: CountryPickerSheet(onSelect: controller.selectCountry),
              ),
              borderRadius: BorderRadius.circular(11),
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1210),
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${state.country.isoCode} ${state.country.dialCode}',
                      style: const TextStyle(color: AppColors.ink, fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, color: AppColors.muted, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 46,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  onChanged: controller.updatePhoneDigits,
                  style: const TextStyle(color: AppColors.ink, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    hintStyle: const TextStyle(color: AppColors.faint),
                    filled: true,
                    fillColor: const Color(0xFF0E1210),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: AppColors.green.withOpacity(0.4)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (state.phoneError != null) ...[
          const SizedBox(height: 8),
          Text(
            state.phoneError!,
            style: const TextStyle(color: AppColors.errorSoft, fontSize: 9),
          ),
        ],
        const Spacer(),
        Row(
          children: [
            PillButton(
              label: 'Back',
              variant: PillButtonVariant.ghost,
              expand: false,
              onPressed: onBack,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: PillButton(
                label: state.isSendingOtp ? 'Sending…' : 'Send code',
                onPressed: state.canSendOtp ? controller.sendOtp : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Standard SMS rates may apply.',
          style: TextStyle(color: AppColors.faint, fontSize: 8),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
