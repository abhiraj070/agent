class Person {
  const Person({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.language,
    required this.initials,
    this.note,
  });

  /// The real backend Member id — there's no client-generated fallback id
  /// anymore. A [Person] only exists once `/add_members` has confirmed it.
  final int id;
  final String name;
  final String role;
  final String phone;
  final String language;
  final String? note;
  final String initials;

  static String initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.map((p) => p[0]).take(2).join();
    return letters.toUpperCase();
  }

  /// Maps a `GET /get-my-members` list item (agent/schema.py's
  /// MemberResponse: id, nick_name, phone_number, role, preferred_language)
  /// onto the app's Person shape. `note` has no backend column, so it's
  /// always null here — only locally-added notes (see [toJson]) survive.
  factory Person.fromMember(Map<String, dynamic> json) {
    final name = json['nick_name'] as String;
    return Person(
      id: json['id'] as int,
      name: name,
      role: json['role'] as String,
      phone: json['phone_number'] as String,
      language: json['preferred_language'] as String,
      initials: initialsFor(name),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json['id'] as int,
        name: json['name'] as String,
        role: json['role'] as String,
        phone: json['phone'] as String,
        language: json['language'] as String,
        note: json['note'] as String?,
        initials: json['initials'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'phone': phone,
        'language': language,
        'note': note,
        'initials': initials,
      };
}
