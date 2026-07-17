import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/activity_item.dart';
import 'providers.dart';

class ActivityController extends StateNotifier<List<ActivityItem>> {
  ActivityController(this._ref)
      : super(_ref.read(activityRepositoryProvider).load());

  final Ref _ref;

  Future<void> add(ActivityItem item) async {
    final deduped =
        state.where((existing) => existing.title != item.title).toList();
    final updated = [item, ...deduped];
    state = updated.length > 12 ? updated.sublist(0, 12) : updated;
    await _ref.read(activityRepositoryProvider).save(state);
  }
}

final activityControllerProvider =
    StateNotifierProvider<ActivityController, List<ActivityItem>>((ref) {
  return ActivityController(ref);
});
