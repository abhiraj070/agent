import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aaraam/data/local/activity_repository.dart';

void main() {
  test('load() falls back to empty instead of throwing on old-shape cached data', () async {
    SharedPreferences.setMockInitialValues({
      'aaraam-activity': '[{"time":"Just now","title":"Rohan confirmed.","meta":"Handled by Aaraam"}]',
    });
    final prefs = await SharedPreferences.getInstance();
    final repo = ActivityRepository(prefs);
    final result = repo.load();
    expect(result, isEmpty);
  });
}
