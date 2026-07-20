import 'package:dio/dio.dart';

import '../../domain/entities/activity_item.dart';
import 'api_exception.dart';

/// Talks to the call/activity-history endpoints in agent/api/user.py.
class CallRepository {
  CallRepository(this._dio);

  final Dio _dio;

  static const _endpoint = '/get-my-activity';

  /// The source of truth for Activity history — see ActivityController.
  /// `GET /get-my-activity` 404s when the user has none yet (rather than
  /// returning an empty list) — that's mapped to a normal ApiException
  /// here, same as any other failure, and the caller falls back quietly.
  Future<List<ActivityItem>> getMyActivity() async {
    try {
      final response = await _dio.get(_endpoint);
      final data = response.data as List<dynamic>;
      return data
          .map((item) => ActivityItem.fromApi(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(_messageFor(e));
    }
  }

  /// Calls `POST /delete-my-activity` with a JSON body matching
  /// agent/schema.py's `DeleteActivityRequest` (`{"id": <int>}`).
  Future<void> deleteActivity(int id) async {
    try {
      await _dio.post('/delete-my-activity', data: {'id': id});
    } on DioException catch (e) {
      throw ApiException(_messageFor(e));
    }
  }

  String _messageFor(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['detail'] is String) {
      return data['detail'] as String;
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'Couldn’t reach the server. Check your connection and try again.';
      default:
        return 'Something went wrong. Try again.';
    }
  }
}
