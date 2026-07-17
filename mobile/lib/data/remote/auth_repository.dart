import 'package:dio/dio.dart';

import '../../domain/entities/auth_tokens.dart';
import 'api_exception.dart';

/// Talks to the Twilio-backed endpoints in agent/api/start.py: `/send-otp`
/// (phone_number as a query param) and `/verify-otp` (form-encoded
/// phone_number + otp_code, returning access/refresh tokens).
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _dio.post(
        '/send-otp',
        queryParameters: {'phone_number': phoneNumber},
      );
    } on DioException catch (e) {
      throw ApiException(_messageFor(e));
    }
  }

  Future<AuthTokens> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final response = await _dio.post(
        '/verify-otp',
        data: FormData.fromMap({
          'phone_number': phoneNumber,
          'otp_code': otpCode,
        }),
      );
      return AuthTokens.fromJson(response.data as Map<String, dynamic>);
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
