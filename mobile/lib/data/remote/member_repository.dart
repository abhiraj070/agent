import 'package:dio/dio.dart';

import '../../domain/entities/person.dart';
import 'api_exception.dart';

/// Talks to the authenticated household-member endpoints in
/// agent/api/member.py and agent/api/user.py.
class MemberRepository {
  MemberRepository(this._dio);

  final Dio _dio;

  /// Calls `POST /add_members` and returns the real backend member id —
  /// there's no client-generated fallback id.
  ///
  /// Note: the backend's `role` field is matched against a fixed enum
  /// server-side (Maid, Driver, Cook, Gardner, House Manager, Nanny, Dog
  /// Walker, Maintenance, Security, or "Other" via the enum name) — a role
  /// string outside that set returns a 422.
  Future<int> addMember({
    required String nickName,
    required String role,
    required String preferredLanguage,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        '/add_members',
        data: {
          'nick_name': nickName,
          'role': role,
          'preferred_language': preferredLanguage,
          'phone_number': phoneNumber,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return data['member_id'] as int;
    } on DioException catch (e) {
      throw ApiException(_messageFor(e));
    }
  }

  /// Calls `GET /get-my-members` — the source of truth for "My People".
  Future<List<Person>> getMyMembers() async {
    try {
      final response = await _dio.get('/get-my-members');
      final data = response.data as List<dynamic>;
      return data
          .map((item) => Person.fromMember(item as Map<String, dynamic>))
          .toList();
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
