import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../../profile/controllers/profile_controller.dart';
import '../data/edit_profile_repository.dart';
import '../data/edit_profile_model.dart' as edit_model;

class EditProfileController extends GetxController {
  late final ProfileController profileController;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final isLoading = false.obs;
  final EditProfileRepository _repo = EditProfileRepository();
  final ImagePicker _picker = ImagePicker();
  final Rxn<XFile> imageFile = Rxn<XFile>();

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

      final edit_model.Data? updated = await _repo.editProfile(
        name: newName,
        email: newEmail,
        phone: newPhone,
        address: newAddress,
        imagePath: imageFile.value?.path,
      );

      if (updated == null) {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Update local ProfileController with returned values
      profileController.updateProfile(
        newUsername: updated.name,
        newEmail: updated.email,
        newPhone: updated.phone,
        newAddress: updated.address,
        newImageUrl: updated.image,
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
        'Failed to save profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        imageFile.value = picked;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
      );
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
