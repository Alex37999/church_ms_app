import 'package:get/get.dart';

import 'reset_pass_controller.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ResetPasswordController>(ResetPasswordController());
  }
}
