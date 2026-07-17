import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/person.dart';

/// Local cache of "My People" — an offline fallback only. The backend
/// (`GET /get-my-members`) is the source of truth; see PeopleController.
class PeopleRepository {
  PeopleRepository(this._prefs);

  static const _key = 'aaraam-people';
  final SharedPreferences _prefs;

  List<Person> load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Person.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<Person> people) async {
    final encoded = jsonEncode(people.map((p) => p.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
