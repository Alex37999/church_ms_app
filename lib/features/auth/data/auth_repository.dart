import '../../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient _client = ApiClient();

  /// Attempt to login. Returns response data (Map) or null on error.
  Future<dynamic> login(Map<String, dynamic> body) async {
    try {
      final res = await _client.post('/auth/login', data: body);
      return res.data;
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
}
