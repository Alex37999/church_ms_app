import 'package:get/get.dart';

import '../profile/bindings/profile_binding.dart';
import '../profile/controllers/profile_controller.dart';
import 'edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ProfileController is available
    if (!Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }

    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}
