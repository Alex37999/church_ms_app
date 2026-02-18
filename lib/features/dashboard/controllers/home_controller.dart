import 'package:get/get.dart';
import '../../../core/controllers/app_controller.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  late final AppController appController;

  @override
  void onInit() {
    super.onInit();
    appController = Get.find<AppController>();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
