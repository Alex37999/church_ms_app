import 'dart:convert';

import 'package:churchmsapp/features/dashboard/data/homepage_model.dart';
import '../../../core/network/api_client.dart';

class HomeRepository {
  final ApiClient _client = ApiClient();

  Future<Homepage?> fetchDashboard() async {
    try {
      final res = await _client.get('/api/member/dashboard');
      // Log raw response
      try {
        print(
          '📥 [HomeRepository] raw dashboard response: ${jsonEncode(res.data)}',
        );
      } catch (_) {}

      if (res.data == null) return null;
      return Homepage.fromJson(Map<String, dynamic>.from(res.data));
    } catch (e) {
      return null;
    }
  }
}
