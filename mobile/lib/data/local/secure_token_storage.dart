import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/auth_tokens.dart';

/// Persists access/refresh tokens in the platform keychain/keystore —
/// never in shared_preferences or app state.
class SecureTokenStorage {
  SecureTokenStorage(this._storage);

  static const _accessKey = 'aaraam-access-token';
  static const _refreshKey = 'aaraam-refresh-token';

  final FlutterSecureStorage _storage;

  Future<void> save(AuthTokens tokens) async {
    await _storage.write(key: _accessKey, value: tokens.accessToken);
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
  }

  Future<AuthTokens?> read() async {
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    if (access == null || refresh == null) return null;
    return AuthTokens(accessToken: access, refreshToken: refresh);
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
