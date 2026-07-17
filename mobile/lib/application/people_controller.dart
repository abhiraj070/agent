import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/person.dart';
import 'providers.dart';

class PeopleController extends StateNotifier<List<Person>> {
  PeopleController(this._ref)
      : super(_ref.read(peopleRepositoryProvider).load());

  final Ref _ref;

  Future<Person> add({
    required String name,
    required String role,
    required String phone,
    required String language,
    String? note,
  }) async {
    final person = Person.create(
      name: name,
      role: role,
      phone: phone,
      language: language,
      note: note,
    );
    state = [...state, person];
    await _ref.read(peopleRepositoryProvider).save(state);
    return person;
  }

  /// Merges [people] into the current list, skipping any whose name already
  /// exists (case-insensitive) — mirrors the mockup's onboarding merge.
  Future<void> addAllIfMissing(List<Person> people) async {
    final updated = [...state];
    for (final person in people) {
      final exists = updated
          .any((p) => p.name.toLowerCase() == person.name.toLowerCase());
      if (!exists) updated.add(person);
    }
    state = updated;
    await _ref.read(peopleRepositoryProvider).save(state);
  }
}

final peopleControllerProvider =
    StateNotifierProvider<PeopleController, List<Person>>((ref) {
  return PeopleController(ref);
});
