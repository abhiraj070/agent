import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../local/secure_token_storage.dart';
import 'auth_interceptor.dart';

/// Backend base URL. Defaults to the local FastAPI dev server (`uvicorn
/// main:app`, default port 8000). Override per environment with
/// `--dart-define=API_BASE_URL=https://your-host` at build/run time —
/// this default has not been confirmed against a real staging/prod host.
///
/// Local dev note: on an Android emulator `localhost` refers to the
/// emulator itself, not your host machine — use `10.0.2.2` instead
/// (`--dart-define=API_BASE_URL=http://10.0.2.2:8000`). iOS simulators and
/// physical devices on the same network don't need this.
class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}

Dio createApiClient(SecureTokenStorage tokenStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(AuthInterceptor(tokenStorage));
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
  return dio;
}
