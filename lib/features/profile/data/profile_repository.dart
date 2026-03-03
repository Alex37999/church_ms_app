import 'dart:convert';

import '../../../core/network/api_client.dart';
import 'profile_model.dart';

class ProfileRepository {
  final ApiClient _client = ApiClient();

  Future<Data?> fetchProfile() async {
    try {
      final res = await _client.get('/api/member/my-profile');
      try {
        print(
          '📥 [ProfileRepository] raw profile response: ${jsonEncode(res.data)}',
        );
      } catch (_) {}

      if (res.data == null) return null;
      final map = Map<String, dynamic>.from(res.data);
      final profile = ProfileGet.fromJson(map);
      return profile.data;
    } catch (e) {
      print('❌ [ProfileRepository] fetchProfile error: $e');
      return null;
    }
  }
}
