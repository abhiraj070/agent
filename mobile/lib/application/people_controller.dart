import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/remote/api_exception.dart';
import '../domain/entities/person.dart';
import 'providers.dart';

/// "My People" — backend-first. `GET /get-my-members` is the source of
/// truth; the local cache exists only as an offline fallback for the
/// first paint before that fetch resolves (or if it fails).
class PeopleController extends StateNotifier<List<Person>> {
  PeopleController(this._ref)
      : super(_ref.read(peopleRepositoryProvider).load()) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    try {
      final members = await _ref.read(memberRepositoryProvider).getMyMembers();
      state = members;
      await _ref.read(peopleRepositoryProvider).save(state);
    } on ApiException {
      // Keep whatever the local cache booted with — offline fallback.
    }
  }

  /// Adds a person via `/add_members` and returns the resulting [Person]
  /// carrying its real backend id. Throws [ApiException] on failure —
  /// there's no local-only add with a made-up id anymore.
  Future<Person> add({
    required String name,
    required String role,
    required String phone,
    required String language,
    String? note,
  }) async {
    final memberId = await _ref.read(memberRepositoryProvider).addMember(
          nickName: name,
          role: role,
          preferredLanguage: language,
          phoneNumber: phone,
        );
    final person = Person(
      id: memberId,
      name: name,
      role: role,
      phone: phone,
      language: language,
      note: note,
      initials: Person.initialsFor(name),
    );
    state = [...state, person];
    await _ref.read(peopleRepositoryProvider).save(state);
    return person;
  }
}

final peopleControllerProvider =
    StateNotifierProvider<PeopleController, List<Person>>((ref) {
  return PeopleController(ref);
});
