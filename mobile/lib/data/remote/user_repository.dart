import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Talks to the authenticated user-profile endpoints in agent/api/user.py.
class UserRepository {
  UserRepository(this._dio);

  final Dio _dio;

  /// Calls `PATCH /add-language`. Requires a signed-in user — the access
  /// token is attached automatically by [AuthInterceptor].
  Future<void> updateLanguage(String language) async {
    try {
      await _dio.patch(
        '/add-language',
        queryParameters: {'language': language},
      );
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
