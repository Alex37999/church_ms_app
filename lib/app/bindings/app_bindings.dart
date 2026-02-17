import 'package:get/get.dart';
import '../../core/controllers/app_controller.dart';
import '../../core/network/api_client.dart';
import '../../core/services/api_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());
    Get.lazyPut<ApiService>(() => ApiService());
    Get.put(AppController());
  }
}
