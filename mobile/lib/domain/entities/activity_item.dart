/// A single past request-and-outcome pair, sourced from the backend's
/// `Activity` table (written as a side effect of `/recieve-message` and
/// `/receive-audio-file`, not via a dedicated client call).
class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.createdAt,
    required this.message,
    required this.response,
  });

  final int id;
  final DateTime createdAt;
  final String message;
  final String response;

  /// Maps a `GET` activity-list item. Field names (`id`, `created_at`,
  /// `message`, `response`) are provisional pending the real endpoint —
  /// adjust here once it's confirmed.
  factory ActivityItem.fromApi(Map<String, dynamic> json) => ActivityItem(
        id: json['id'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        message: json['message'] as String,
        response: json['response'] as String,
      );

  factory ActivityItem.fromJson(Map<String, dynamic> json) => ActivityItem(
        id: json['id'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        message: json['message'] as String,
        response: json['response'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'message': message,
        'response': response,
      };
}
