import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/activity_repository.dart';
import '../data/local/language_preference_repository.dart';
import '../data/local/onboarding_repository.dart';
import '../data/local/people_repository.dart';
import '../data/local/secure_token_storage.dart';
import '../data/remote/api_client.dart';
import '../data/remote/audio_repository.dart';
import '../data/remote/auth_repository.dart';
import '../data/remote/chat_repository.dart';
import '../data/remote/member_repository.dart';
import '../data/remote/user_repository.dart';

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

final languagePreferenceRepositoryProvider =
    Provider<LanguagePreferenceRepository>((ref) {
  return LanguagePreferenceRepository(ref.watch(sharedPreferencesProvider));
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(ref.watch(secureStorageProvider));
});

final dioProvider = Provider<Dio>((ref) {
  return createApiClient(ref.watch(secureTokenStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(dioProvider));
});

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepository(ref.watch(dioProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(dioProvider));
});

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepository(ref.watch(dioProvider));
});
