class ActivityItem {
  const ActivityItem({
    required this.time,
    required this.title,
    required this.meta,
  });

  final String time;
  final String title;
  final String meta;

  factory ActivityItem.fromJson(Map<String, dynamic> json) => ActivityItem(
        time: json['time'] as String,
        title: json['title'] as String,
        meta: json['meta'] as String,
      );

  Map<String, dynamic> toJson() => {
        'time': time,
        'title': title,
        'meta': meta,
      };
}
