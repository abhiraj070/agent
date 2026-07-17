import 'package:shared_preferences/shared_preferences.dart';

/// The app owner's preferred reply language. Local-only for now: the
/// backend's User table has no column for it yet (only Member —
/// individual contacts — carries preferred_language). Revisit once
/// there's a server-side place to put this.
class LanguagePreferenceRepository {
  LanguagePreferenceRepository(this._prefs);

  static const _key = 'aaraam-reply-language';
  final SharedPreferences _prefs;

  String? load() => _prefs.getString(_key);

  Future<void> save(String language) async {
    await _prefs.setString(_key, language);
  }
}
