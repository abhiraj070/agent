import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Talks to the authenticated orchestrator endpoint in agent/api/chat.py.
/// Requires a live `/ws` connection behind `connectionId` — see
/// ChatSocketController — or every call the orchestrator tries to place
/// will fail server-side with "WebSocket connection is no longer active."
class ChatRepository {
  ChatRepository(this._dio);

  final Dio _dio;

  Future<String> sendMessage({
    required String connectionId,
    required String message,
  }) async {
    try {
      // The orchestrator may place real phone calls before replying, which
      // can take much longer than a typical API round trip.
      final response = await _dio.post(
        '/recieve-message',
        data: {'connection_id': connectionId, 'message': message},
        options: Options(receiveTimeout: const Duration(seconds: 90)),
      );
      final data = response.data as Map<String, dynamic>;
      return data['response'] as String;
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
