import 'package:get/get.dart';
import '../services/api_service.dart';

class AppController extends GetxController {
  final String env = const String.fromEnvironment('ENV', defaultValue: 'dev');
  late final ApiService apiService;

  @override
  void onInit() {
    super.onInit();
    apiService = Get.find<ApiService>();
  }

  Future<dynamic> fetchStatus() async {
    try {
      final data = await apiService.fetchStatus();
      return data;
    } catch (e) {
      return e.toString();
    }
  }
}
