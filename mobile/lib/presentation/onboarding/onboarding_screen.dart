import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/onboarding_controller.dart';
import '../../core/theme/app_colors.dart';
import 'steps/add_person_step.dart';
import 'steps/demo_step.dart';
import 'steps/first_instruction_step.dart';
import 'steps/first_result_step.dart';
import 'steps/privacy_step.dart';
import 'steps/welcome_step.dart';

/// Ports the `Onboarding` component from UI_design/app/page.tsx: a 6-step
/// flow with a shared top bar (brand + progress dots) and a step body that
/// swaps underneath it.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.stageBackground),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(23, 8, 23, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 27,
                        height: 27,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.soft,
                          border: Border.all(
                            color: AppColors.green.withOpacity(0.28),
                          ),
                        ),
                        child: const Text(
                          'अ',
                          style: TextStyle(color: AppColors.green, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Aaraam',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: List.generate(6, (index) {
                      final active = index == state.step;
                      final passed = index < state.step;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(left: 6),
                        width: active ? 18 : 4,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: active
                              ? AppColors.green.withOpacity(0.8)
                              : passed
                                  ? AppColors.green.withOpacity(0.28)
                                  : Colors.white.withOpacity(0.14),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 12, 25, 24),
                child: _buildStep(context, state, controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    OnboardingState state,
    OnboardingController controller,
  ) {
    switch (state.step) {
      case 0:
        return WelcomeStep(onBegin: () => controller.goToStep(1));
      case 1:
        return DemoStep(
          exampleIndex: state.exampleIndex,
          onBack: () => controller.goToStep(0),
          onContinue: () => controller.goToStep(2),
        );
      case 2:
        return PrivacyStep(
          onBack: () => controller.goToStep(1),
          onContinue: () => controller.goToStep(3),
        );
      case 3:
        return AddPersonStep(
          hasExistingPending: state.pendingPeople.isNotEmpty,
          onBack: () => controller.goToStep(2),
          onSubmit: controller.submitFirstPerson,
        );
      case 4:
        final person = state.activePerson;
        if (person == null) {
          return WelcomeStep(onBegin: () => controller.goToStep(1));
        }
        return FirstInstructionStep(
          person: person,
          instruction: state.firstInstruction,
          onInstructionChanged: controller.updateFirstInstruction,
          onSubmit: controller.submitFirstInstruction,
          onAddAnother: () => controller.goToStep(3),
        );
      case 5:
        final person = state.activePerson;
        if (person == null) {
          return WelcomeStep(onBegin: () => controller.goToStep(1));
        }
        return FirstResultStep(
          person: person,
          instruction: state.firstInstruction,
          done: state.firstTaskDone,
          outcome: state.firstOutcome,
          onComplete: controller.completeOnboarding,
        );
      default:
        return WelcomeStep(onBegin: () => controller.goToStep(1));
    }
  }
}
