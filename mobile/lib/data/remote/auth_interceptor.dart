import 'package:dio/dio.dart';

import '../../domain/entities/auth_tokens.dart';
import '../local/secure_token_storage.dart';

/// Attaches the stored access/refresh tokens to every outgoing request, and
/// picks up a silently-refreshed access token off the response — mirrors
/// `get_current_user` in Auth/VerifyJWT.py, which reads `Authorization:
/// Bearer <access>` plus an `X-Refresh-Token` fallback header, and returns
/// a new access token via the `X-Access-Token` response header when the
/// access token had expired but the refresh token was still valid.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final SecureTokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tokens = await _tokenStorage.read();
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      options.headers['X-Refresh-Token'] = tokens.refreshToken;
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final refreshedAccessToken = response.headers.value('x-access-token');
    if (refreshedAccessToken != null) {
      final tokens = await _tokenStorage.read();
      if (tokens != null) {
        await _tokenStorage.save(
          AuthTokens(
            accessToken: refreshedAccessToken,
            refreshToken: tokens.refreshToken,
          ),
        );
      }
    }
    handler.next(response);
  }
}
