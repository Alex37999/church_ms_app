import 'package:get/get.dart';

import 'signup_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
