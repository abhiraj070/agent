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

  final int id;
  final String name;
  final String role;
  final String phone;
  final String language;
  final String? note;
  final String initials;

  factory Person.create({
    required String name,
    required String role,
    required String phone,
    required String language,
    String? note,
  }) {
    return Person(
      id: DateTime.now().microsecondsSinceEpoch,
      name: name,
      role: role,
      phone: phone,
      language: language,
      note: note,
      initials: _initialsFor(name),
    );
  }

  static String _initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.map((p) => p[0]).take(2).join();
    return letters.toUpperCase();
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
