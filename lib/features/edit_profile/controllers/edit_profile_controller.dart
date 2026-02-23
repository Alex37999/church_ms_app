import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  late final ProfileController profileController;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    profileController = Get.find<ProfileController>();
    // initialize form controllers from profile
    nameCtrl.text = profileController.username.value;
    emailCtrl.text = profileController.email.value;
    phoneCtrl.text = profileController.phoneNumber.value;
    addressCtrl.text = profileController.address.value;
  }

  /// Validate and save changes back to `ProfileController`.
  Future<void> saveChanges() async {
    final newName = nameCtrl.text.trim();
    final newEmail = emailCtrl.text.trim();
    final newPhone = phoneCtrl.text.trim();
    final newAddress = addressCtrl.text.trim();

    if (newName.isEmpty) {
      Get.snackbar(
        'Validation',
        'Name is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (newEmail.isEmpty || !newEmail.contains('@')) {
      Get.snackbar(
        'Validation',
        'Enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // In a real app, you'd call an API here. For now update local controller.
      profileController.updateProfile(
        newUsername: newName,
        newEmail: newEmail,
        newPhone: newPhone,
        newAddress: newAddress,
      );

      Get.snackbar(
        'Saved',
        'Profile updated',
        snackPosition: SnackPosition.BOTTOM,
      );
      // close screen
      await Future.delayed(const Duration(milliseconds: 200));
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
