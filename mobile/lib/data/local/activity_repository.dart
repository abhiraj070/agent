import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/activity_item.dart';
import 'seed_data.dart';

/// Mirrors the mockup's `localStorage` key "aaraam-activity".
class ActivityRepository {
  ActivityRepository(this._prefs);

  static const _key = 'aaraam-activity';
  final SharedPreferences _prefs;

  List<ActivityItem> load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return SeedData.activitySeed;
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => ActivityItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<ActivityItem> activity) async {
    final encoded = jsonEncode(activity.map((a) => a.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
