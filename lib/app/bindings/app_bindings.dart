import 'package:get/get.dart';
import '../../core/controllers/app_controller.dart';
import '../../core/controllers/theme_controller.dart';
import '../../core/network/api_client.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core services and API
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);

    // Simple storage service (stub)
    Get.put<StorageService>(StorageService(), permanent: true);

    // Theme controller (global)
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // Global controller
    Get.put(AppController(), permanent: true);
  }
}
