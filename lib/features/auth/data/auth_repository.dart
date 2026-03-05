import '../../../core/network/api_client.dart';
import 'dart:convert';
import 'login_model.dart';

class AuthRepository {
  final ApiClient _client = ApiClient();

  /// Attempt to login. Returns [Login] model or null on error.
  Future<Login?> login(Map<String, dynamic> body) async {
    try {
      final res = await _client.post('/api/member/login', data: body);
      // Log raw response for debugging
      try {
        print('🔁 [AuthRepository] raw response JSON: ${jsonEncode(res.data)}');
      } catch (_) {}
      if (res.data == null) return null;
      if (res.data is Map<String, dynamic>) {
        return Login.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> register(Map<String, dynamic> body) async {
    try {
      final res = await _client.post('/auth/register', data: body);
      return res.data;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> forgotPassword(Map<String, dynamic> body) async {
    try {
      final res = await _client.post('/auth/forgot-password', data: body);
      return res.data;
    } catch (e) {
      return null;
    }
  }

  /// Call logout endpoint. Returns true when logout succeeded.
  Future<bool> logout() async {
    try {
      final res = await _client.post('/api/member/logout');
      try {
        print(
          '🔁 [AuthRepository] logout raw response JSON: ${jsonEncode(res.data)}',
        );
      } catch (_) {}
      if (res.data is Map) {
        final map = Map<String, dynamic>.from(res.data as Map);
        final success = map['success'] == true;
        if (success) return true;

        final message = map['message']?.toString().toLowerCase().trim();
        if (message != null && message.contains('unauthenticated')) {
          // Token/session already invalid; consider this a successful local logout.
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
