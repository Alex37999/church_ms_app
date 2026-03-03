import 'package:get/get.dart';
import '../../../core/controllers/app_controller.dart';
import '../data/homepage_model.dart';
import '../data/home_repository.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  late final AppController appController;

  final homepage = Rxn<Homepage>();
  final isLoading = false.obs;

  final HomeRepository _repo = HomeRepository();

  @override
  void onInit() {
    super.onInit();
    appController = Get.find<AppController>();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      final res = await _repo.fetchDashboard();
      if (res != null && res.success == true) {
        homepage.value = res;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
