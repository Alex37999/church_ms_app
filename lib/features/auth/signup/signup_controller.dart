import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import '../../../core/services/storage_service.dart';
import '../data/auth_repository.dart';

class RegisterController extends GetxController {
  // controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  // Error observables
  final nameError = RxString('');
  final emailError = RxString('');
  final passwordError = RxString('');
  final confirmPasswordError = RxString('');

  // toggles
  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  // theme toggle - delegate to global ThemeController
  void toggleTheme() => Get.find<ThemeController>().toggleTheme();

  final _authRepository = AuthRepository();

  // register action (calls real API)
  Future<void> register() async {
    // Clear previous errors
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';

    // Validate name
    if (fullNameController.text.trim().isEmpty) {
      nameError.value = 'Full name is required';
    }

    // Validate email
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!emailController.text.contains('@')) {
      emailError.value = 'Enter a valid email';
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Minimum 6 characters';
    }

    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    }

    // If there are errors, don't proceed with registration
    if (nameError.value.isNotEmpty ||
        emailError.value.isNotEmpty ||
        passwordError.value.isNotEmpty ||
        confirmPasswordError.value.isNotEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      // Match Postman request body: name, email, password
      final body = {
        'name': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      final registerResponse = await _authRepository.register(body);

      // If API returned a map with data.access_token -> success
      if (registerResponse is Map<String, dynamic> &&
          registerResponse['data'] != null &&
          registerResponse['data']['access_token'] != null &&
          (registerResponse['data']['access_token'] as String).isNotEmpty) {
        final storage = Get.find<StorageService>();
        final token = registerResponse['data']['access_token'] as String;
        await storage.saveToken(token);

        final user = registerResponse['data']['user'];

        if (user is Map<String, dynamic>) {
          await storage.saveUserId(user['id']?.toString() ?? '');
          await storage.saveUserEmail(user['email'] ?? '');
          await storage.saveUserFullName(user['name'] ?? '');
        }
        await storage.setLoggedIn(true);

        isLoading.value = false;
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Users are automatically verified, navigate to home
        Get.offAllNamed('/home');
        return;
      }

      // If API returned validation errors, show them
      if (registerResponse is Map<String, dynamic>) {
        final errors = registerResponse['errors'];
        String message = registerResponse['message'] ?? 'Registration failed';
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          // Flatten first error messages
          final parts = <String>[];
          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty)
              parts.add(value.first.toString());
            else if (value is String)
              parts.add(value);
          });
          if (parts.isNotEmpty) message = parts.join('\n');
        }
        isLoading.value = false;
        Get.snackbar(
          'Registration Failed',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Fallback
      isLoading.value = false;
      Get.snackbar(
        'Registration Failed',
        'Unable to create account. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void navigateToLogin() => Get.toNamed('/login');

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
