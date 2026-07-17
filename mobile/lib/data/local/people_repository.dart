import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/person.dart';
import 'seed_data.dart';

/// Mirrors the mockup's `localStorage` key "aaraam-people".
class PeopleRepository {
  PeopleRepository(this._prefs);

  static const _key = 'aaraam-people';
  final SharedPreferences _prefs;

  List<Person> load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return SeedData.initialPeople;
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
