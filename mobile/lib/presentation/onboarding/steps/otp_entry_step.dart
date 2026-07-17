import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/account_setup_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/mini_step_dots.dart';
import '../../../core/widgets/pill_button.dart';

/// Second part of the account-setup sub-flow — 6-digit OTP verification.
/// The visible boxes are decorative; a single invisible TextField layered
/// on top captures the real input, avoiding a dedicated pin-code package.
class OtpEntryStep extends ConsumerStatefulWidget {
  const OtpEntryStep({super.key});

  @override
  ConsumerState<OtpEntryStep> createState() => _OtpEntryStepState();
}

class _OtpEntryStepState extends ConsumerState<OtpEntryStep> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountSetupControllerProvider);
    final controller = ref.read(accountSetupControllerProvider.notifier);

    if (_otpController.text != state.otpCode) {
      _otpController.value = TextEditingValue(
        text: state.otpCode,
        selection: TextSelection.collapsed(offset: state.otpCode.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MiniStepDots(stepCount: 3, activeIndex: 1),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: controller.changeNumber,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              '‹ Change number',
              style: TextStyle(color: AppColors.faint, fontSize: 9),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text('VERIFY IT’S YOU', style: AppTextStyles.eyebrow),
        const SizedBox(height: 13),
        const Text('Enter the code\nwe sent you.', style: AppTextStyles.headline),
        const SizedBox(height: 15),
        Text('Sent to ${state.fullPhoneNumber}', style: AppTextStyles.subline),
        const SizedBox(height: 20),
        SizedBox(
          height: 52,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  final filled = index < state.otpCode.length;
                  return Container(
                    width: 44,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: filled ? AppColors.green.withOpacity(0.4) : AppColors.line,
                      ),
                    ),
                    child: Text(
                      filled ? state.otpCode[index] : '',
                      style: const TextStyle(color: AppColors.ink, fontSize: 16),
                    ),
                  );
                }),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _otpController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: controller.updateOtpCode,
                    onSubmitted: (_) {
                      if (state.canVerifyOtp) controller.verifyOtp();
                    },
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (state.otpError != null) ...[
          const SizedBox(height: 10),
          Text(
            state.otpError!,
            style: const TextStyle(color: AppColors.errorSoft, fontSize: 9),
          ),
        ],
        const SizedBox(height: 12),
        state.resendCooldownSeconds > 0
            ? Text(
                'Resend code in 0:${state.resendCooldownSeconds.toString().padLeft(2, '0')}',
                style: const TextStyle(color: AppColors.faint, fontSize: 9),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: controller.resendOtp,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Resend code',
                    style: TextStyle(color: AppColors.green, fontSize: 9),
                  ),
                ),
              ),
        const Spacer(),
        PillButton(
          label: state.isVerifyingOtp ? 'Verifying…' : 'Verify',
          onPressed: state.canVerifyOtp ? controller.verifyOtp : null,
        ),
      ],
    );
  }
}
