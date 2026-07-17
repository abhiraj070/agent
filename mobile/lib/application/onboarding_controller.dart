import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/seed_data.dart';
import '../domain/entities/activity_item.dart';
import '../domain/entities/person.dart';
import 'activity_controller.dart';
import 'app_stage_controller.dart';
import 'people_controller.dart';
import 'providers.dart';

class OnboardingState {
  const OnboardingState({
    this.step = 0,
    this.pendingPeople = const [],
    this.activePerson,
    this.firstInstruction = '',
    this.firstTaskDone = false,
    this.exampleIndex = 0,
  });

  final int step;
  final List<Person> pendingPeople;
  final Person? activePerson;
  final String firstInstruction;
  final bool firstTaskDone;
  final int exampleIndex;

  String get firstOutcome => activePerson != null
      ? '${activePerson!.name} confirmed your request.'
      : 'Your request was confirmed.';

  OnboardingState copyWith({
    int? step,
    List<Person>? pendingPeople,
    Person? activePerson,
    String? firstInstruction,
    bool? firstTaskDone,
    int? exampleIndex,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      pendingPeople: pendingPeople ?? this.pendingPeople,
      activePerson: activePerson ?? this.activePerson,
      firstInstruction: firstInstruction ?? this.firstInstruction,
      firstTaskDone: firstTaskDone ?? this.firstTaskDone,
      exampleIndex: exampleIndex ?? this.exampleIndex,
    );
  }
}

/// Ports the `Onboarding` component's step machine from
/// UI_design/app/page.tsx: 6 steps, a rotating example carousel on step 1,
/// and a fake "reaching them" delay on step 5.
class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._ref) : super(const OnboardingState());

  final Ref _ref;
  Timer? _exampleTimer;
  Timer? _resultTimer;

  void goToStep(int step) {
    state = state.copyWith(step: step);
    if (step == 1) {
      _startExampleRotation();
    } else {
      _exampleTimer?.cancel();
    }
    if (step == 5) {
      _startFirstTaskTimer();
    } else {
      _resultTimer?.cancel();
    }
  }

  void _startExampleRotation() {
    _exampleTimer?.cancel();
    state = state.copyWith(exampleIndex: 0);
    _exampleTimer = Timer.periodic(const Duration(milliseconds: 3900), (_) {
      state = state.copyWith(
        exampleIndex:
            (state.exampleIndex + 1) % SeedData.onboardingExamples.length,
      );
    });
  }

  void _startFirstTaskTimer() {
    _resultTimer?.cancel();
    state = state.copyWith(firstTaskDone: false);
    _resultTimer = Timer(const Duration(milliseconds: 2400), () {
      state = state.copyWith(firstTaskDone: true);
    });
  }

  void submitFirstPerson({
    required String name,
    required String role,
    required String phone,
    required String language,
  }) {
    final person = Person.create(
      name: name.trim().isEmpty ? 'My person' : name.trim(),
      role: role,
      phone: phone.trim().isEmpty ? '+91' : phone.trim(),
      language: language,
      note: 'Added during first setup',
    );
    state = state.copyWith(
      pendingPeople: [...state.pendingPeople, person],
      activePerson: person,
      firstInstruction: '',
    );
    goToStep(4);
  }

  void updateFirstInstruction(String value) {
    state = state.copyWith(firstInstruction: value);
  }

  void submitFirstInstruction() {
    if (state.firstInstruction.trim().isEmpty) return;
    goToStep(5);
  }

  Future<void> completeOnboarding() async {
    await _ref
        .read(peopleControllerProvider.notifier)
        .addAllIfMissing(state.pendingPeople);
    await _ref.read(activityControllerProvider.notifier).add(
          ActivityItem(
            time: 'Just now',
            title: state.firstOutcome,
            meta: 'First request',
          ),
        );
    await _ref.read(onboardingRepositoryProvider).markOnboarded();
    _ref.read(appStageControllerProvider.notifier).enterMain();
  }

  @override
  void dispose() {
    _exampleTimer?.cancel();
    _resultTimer?.cancel();
    super.dispose();
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(ref);
});
