import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/seed_data.dart';
import '../data/remote/api_exception.dart';
import '../domain/entities/person.dart';
import 'app_stage_controller.dart';
import 'providers.dart';

class OnboardingState {
  const OnboardingState({
    this.step = 0,
    this.pendingPeople = const [],
    this.activePerson,
    this.firstInstruction = '',
    this.firstTaskDone = false,
    this.exampleIndex = 0,
    this.isAddingPerson = false,
    this.addPersonError,
  });

  final int step;
  final List<Person> pendingPeople;
  final Person? activePerson;
  final String firstInstruction;
  final bool firstTaskDone;
  final int exampleIndex;
  final bool isAddingPerson;
  final String? addPersonError;

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
    bool? isAddingPerson,
    String? addPersonError,
    bool clearAddPersonError = false,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      pendingPeople: pendingPeople ?? this.pendingPeople,
      activePerson: activePerson ?? this.activePerson,
      firstInstruction: firstInstruction ?? this.firstInstruction,
      firstTaskDone: firstTaskDone ?? this.firstTaskDone,
      exampleIndex: exampleIndex ?? this.exampleIndex,
      isAddingPerson: isAddingPerson ?? this.isAddingPerson,
      addPersonError:
          clearAddPersonError ? null : (addPersonError ?? this.addPersonError),
    );
  }
}

/// Ports the `Onboarding` component's step machine from
/// UI_design/app/page.tsx, extended with an account-setup step (phone/OTP/
/// reply language) between Privacy and Add Person: 0 Welcome, 1 Demo,
/// 2 Privacy, 3 Account setup, 4 Add person, 5 First instruction, 6 Result.
/// Step 1 runs a rotating example carousel; step 6 runs a fake "reaching
/// them" delay.
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
    if (step == 6) {
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

  /// Calls `/add_members` directly (not through PeopleController) so this
  /// person is fully synced before PeopleController ever gets constructed
  /// — that controller's own first-read `refresh()` will pick them up
  /// naturally once the user reaches the main screen, with no separate
  /// merge step and no race between two things writing to its state at
  /// once.
  Future<void> submitFirstPerson({
    required String name,
    required String role,
    required String phone,
    required String language,
  }) async {
    final resolvedName = name.trim().isEmpty ? 'My person' : name.trim();
    final resolvedPhone = phone.trim().isEmpty ? '+91' : phone.trim();
    state = state.copyWith(isAddingPerson: true, clearAddPersonError: true);
    try {
      final memberId = await _ref.read(memberRepositoryProvider).addMember(
            nickName: resolvedName,
            role: role,
            preferredLanguage: language,
            phoneNumber: resolvedPhone,
          );
      final person = Person(
        id: memberId,
        name: resolvedName,
        role: role,
        phone: resolvedPhone,
        language: language,
        note: 'Added during first setup',
        initials: Person.initialsFor(resolvedName),
      );
      state = state.copyWith(
        pendingPeople: [...state.pendingPeople, person],
        activePerson: person,
        firstInstruction: '',
        isAddingPerson: false,
      );
      goToStep(5);
    } on ApiException catch (e) {
      state = state.copyWith(isAddingPerson: false, addPersonError: e.message);
    }
  }

  void updateFirstInstruction(String value) {
    state = state.copyWith(firstInstruction: value);
  }

  void submitFirstInstruction() {
    if (state.firstInstruction.trim().isEmpty) return;
    goToStep(6);
  }

  /// Lets the user bail out of onboarding early (from the add-person or
  /// first-instruction steps) straight to the main screen. Marks onboarding
  /// as done so they land on the home screen again next launch, rather than
  /// being dropped back into this flow.
  Future<void> skipToMain() async {
    await _ref.read(onboardingRepositoryProvider).markOnboarded();
    _ref.read(appStageControllerProvider.notifier).enterMain();
  }

  /// The onboarding "first instruction" step is a simulated success (see
  /// [_startFirstTaskTimer]) — it never actually calls the backend, so
  /// there's no real Activity record for it. Nothing to log here now that
  /// Activity is backend-only.
  Future<void> completeOnboarding() async {
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
