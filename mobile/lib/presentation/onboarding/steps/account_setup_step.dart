import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/account_setup_controller.dart';
import 'otp_entry_step.dart';
import 'phone_entry_step.dart';
import 'response_language_step.dart';

/// Wraps the phone → OTP → language sub-flow (onboarding step 3) and
/// switches between its three parts based on [AccountSetupController]'s
/// stage.
class AccountSetupStep extends ConsumerWidget {
  const AccountSetupStep({
    super.key,
    required this.onBack,
    required this.onContinue,
  });

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = ref.watch(
      accountSetupControllerProvider.select((state) => state.stage),
    );

    return switch (stage) {
      AccountSetupStage.phone => PhoneEntryStep(onBack: onBack),
      AccountSetupStage.otp => const OtpEntryStep(),
      AccountSetupStage.language => ResponseLanguageStep(onContinue: onContinue),
    };
  }
}
