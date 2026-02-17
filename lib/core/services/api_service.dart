import '../network/api_client.dart';

class ApiService {
  final ApiClient _client = ApiClient();

  Future<dynamic> fetchStatus() async {
    final res = await _client.get('/status');
    return res.data;
  }
}
