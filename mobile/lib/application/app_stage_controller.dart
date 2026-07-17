import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

enum AppStage { splash, onboarding, main }

class AppStageController extends StateNotifier<AppStage> {
  AppStageController(this._ref) : super(AppStage.splash) {
    _bootstrap();
  }

  final Ref _ref;

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final onboarded = _ref.read(onboardingRepositoryProvider).hasOnboarded;
    state = onboarded ? AppStage.main : AppStage.onboarding;
  }

  void enterMain() => state = AppStage.main;
}

final appStageControllerProvider =
    StateNotifierProvider<AppStageController, AppStage>((ref) {
  return AppStageController(ref);
});
