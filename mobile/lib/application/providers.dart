import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/activity_repository.dart';
import '../data/local/onboarding_repository.dart';
import '../data/local/people_repository.dart';

/// Overridden in main() once `SharedPreferences.getInstance()` resolves.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden before use',
  );
});

final peopleRepositoryProvider = Provider<PeopleRepository>((ref) {
  return PeopleRepository(ref.watch(sharedPreferencesProvider));
});

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository(ref.watch(sharedPreferencesProvider));
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(ref.watch(sharedPreferencesProvider));
});
