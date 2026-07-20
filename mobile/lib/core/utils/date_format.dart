const _monthAbbrs = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _formatTime(DateTime dt) {
  final hour24 = dt.hour;
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = hour24 < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}

/// "Today, 4:32 PM" / "Yesterday, 11:02 AM" / "Jul 12, 9:15 AM" — used in
/// the Activity list row.
String formatActivityTimestamp(DateTime timestamp) {
  final local = timestamp.toLocal();
  final now = DateTime.now();
  final time = _formatTime(local);
  if (_isSameDay(local, now)) return 'Today, $time';
  final yesterday = now.subtract(const Duration(days: 1));
  if (_isSameDay(local, yesterday)) return 'Yesterday, $time';
  return '${_monthAbbrs[local.month - 1]} ${local.day}, $time';
}

/// "Jul 12, 2026 · 9:15 AM" — used on the Activity detail page.
String formatActivityDate(DateTime timestamp) {
  final local = timestamp.toLocal();
  return '${_monthAbbrs[local.month - 1]} ${local.day}, ${local.year} · ${_formatTime(local)}';
}
