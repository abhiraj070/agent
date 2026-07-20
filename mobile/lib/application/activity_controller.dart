import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/remote/api_exception.dart';
import '../domain/entities/activity_item.dart';
import 'providers.dart';

/// Activity history — backend-first. The `Activity` table is the source
/// of truth (rows are written server-side as a side effect of
/// `/recieve-message` and `/receive-audio-file`, never by a client call);
/// the local cache exists only as an offline fallback for the first paint
/// before that fetch resolves, or if it fails.
class ActivityController extends StateNotifier<List<ActivityItem>> {
  ActivityController(this._ref)
      : super(_ref.read(activityRepositoryProvider).load()) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    try {
      final items = await _ref.read(callRepositoryProvider).getMyActivity();
      state = items;
      await _ref.read(activityRepositoryProvider).save(state);
    } on ApiException {
      // Keep whatever the local cache booted with — offline fallback.
    }
  }

  /// Deletes one record via `/delete-my-activity`. Unlike [refresh], a
  /// user-initiated delete should surface failure rather than fail
  /// silently — [ApiException] propagates to the caller.
  Future<void> delete(int id) async {
    await _ref.read(callRepositoryProvider).deleteActivity(id);
    state = state.where((item) => item.id != id).toList();
    await _ref.read(activityRepositoryProvider).save(state);
  }
}

final activityControllerProvider =
    StateNotifierProvider<ActivityController, List<ActivityItem>>((ref) {
  return ActivityController(ref);
});
