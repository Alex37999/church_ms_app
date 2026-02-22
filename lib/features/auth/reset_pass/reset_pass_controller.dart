import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import '../data/auth_repository.dart';

class ResetPasswordController extends GetxController {
  final emailController = TextEditingController();

  final isLoading = false.obs;
  final emailError = RxString(''); // Error observable
  final _authRepository = AuthRepository();

  // Theme is handled globally by ThemeController
  void toggleTheme() => Get.find<ThemeController>().toggleTheme();

  Future<void> sendResetLink() async {
    // Clear previous error
    emailError.value = '';

    // Validate email
    if (emailController.text.isEmpty) {
      emailError.value = "Email is required";
    } else if (!emailController.text.contains("@")) {
      emailError.value = "Enter a valid email";
    }

    // If there is error, don't proceed
    if (emailError.value.isNotEmpty) {
      return;
    }

    isLoading.value = true;

    try {
      final body = {'email': emailController.text.trim()};

      final response = await _authRepository.forgotPassword(body);

      if (response != null) {
        final success = response['success'] ?? false;
        final message = response['message'] ?? "Password reset link sent";

        if (success) {
          Get.snackbar(
            "Success",
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          // Clear the email field after success
          await Future.delayed(const Duration(milliseconds: 500));
          emailController.clear();
        } else {
          Get.snackbar(
            "Error",
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to send reset link. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBackToLogin() => Get.back();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
