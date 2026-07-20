import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/activity_item.dart';

/// Local cache of Activity history — an offline fallback only. The
/// backend is the source of truth; see ActivityController.
class ActivityRepository {
  ActivityRepository(this._prefs);

  static const _key = 'aaraam-activity';
  final SharedPreferences _prefs;

  /// Returns `[]` if the cache is empty, missing, or in an old/incompatible
  /// shape (e.g. from before a schema change) rather than throwing — this
  /// is only ever an offline-fallback for the first paint, and
  /// [ActivityController] fetches the real, current data right after.
  List<ActivityItem> load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => ActivityItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> save(List<ActivityItem> activity) async {
    final encoded = jsonEncode(activity.map((a) => a.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
