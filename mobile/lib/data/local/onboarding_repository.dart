import 'package:shared_preferences/shared_preferences.dart';

/// Mirrors the mockup's `localStorage` key "aaraam-onboarded-v1".
class OnboardingRepository {
  OnboardingRepository(this._prefs);

  static const _key = 'aaraam-onboarded-v1';
  final SharedPreferences _prefs;

  bool get hasOnboarded => _prefs.getBool(_key) ?? false;

  Future<void> markOnboarded() async {
    await _prefs.setBool(_key, true);
  }
}
