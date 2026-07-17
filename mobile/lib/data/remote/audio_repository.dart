import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Uploads a recorded voice message to the backend. The backend owns
/// transcription and everything downstream of it (including placing any
/// calls) and returns the same outcome shape as [ChatRepository] —
/// this repository's only extra job is getting the audio file there.
class AudioRepository {
  AudioRepository(this._dio);

  final Dio _dio;

  /// Calls `POST /receive-audio-file`: multipart form data with the
  /// recording under the field name `audio` plus `connection_id` (needed
  /// server-side the same way `/recieve-message` needs it — see
  /// [ChatRepository]). Requires a signed-in user — the access token is
  /// attached automatically by [AuthInterceptor]. Returns the real
  /// outcome text once the orchestrator finishes.
  Future<String> uploadRecording({
    required String filePath,
    required String connectionId,
  }) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'connection_id': connectionId,
        'audio': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      // The orchestrator may place real phone calls before replying, same
      // as /recieve-message.
      final response = await _dio.post(
        '/receive-audio-file',
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 90),
        ),
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
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return 'Couldn’t reach the server. Check your connection and try again.';
      default:
        return 'Upload failed. Try again.';
    }
  }
}
