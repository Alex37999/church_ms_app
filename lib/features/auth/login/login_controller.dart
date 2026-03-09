import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import 'dart:convert';
import '../data/auth_repository.dart';
import 'package:churchmsapp/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  // Branch selection
  final branches = <String>[
    'Westside Branch',
    'Eastside Branch',
    'Central Branch',
    'Northside Branch',
    'Southside Branch',
  ];

  final selectedBranch = ''.obs;

  // Error observables
  final emailError = RxString('');
  final passwordError = RxString('');

  final _authRepository = AuthRepository();

  Future<void> login({GlobalKey<FormState>? formKey}) async {
    // Clear previous errors
    emailError.value = '';
    passwordError.value = '';

    // Validate email
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Enter a valid email';
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    }

    // If there are errors, don't proceed with login
    if (emailError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      final body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      final loginResponse = await _authRepository.login(body);

      // Log parsed response model as JSON
      try {
        print(
          '🔐 [LoginController] parsed response JSON: ${jsonEncode(loginResponse?.toJson())}',
        );
      } catch (_) {}

      // If API call failed or returned null, show failure and exit.
      if (loginResponse == null) {
        Get.snackbar(
          'Login Failed',
          'Unable to contact server. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Successful response
      if (loginResponse.success == true &&
          loginResponse.token != null &&
          loginResponse.token!.isNotEmpty) {
        // Save token
        await Get.find<StorageService>().saveToken(loginResponse.token!);

        // Save user data
        final member = loginResponse.member;
        if (member != null) {
          if (member.id != null) {
            await Get.find<StorageService>().saveUserId(member.id.toString());
          }
          if (member.name != null) {
            await Get.find<StorageService>().saveUserFullName(member.name!);
          }
          if (member.email != null) {
            await Get.find<StorageService>().saveUserEmail(member.email!);
          }
        }

        await Get.find<StorageService>().setLoggedIn(true);

        Get.snackbar(
          'Success 🎉',
          loginResponse.message ?? 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed(Routes.HOME);
        return;
      }

      // If not successful, show server message
      final errMsg = loginResponse.message ?? 'Invalid email or password.';
      Get.snackbar(
        'Login Failed',
        errMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        'Invalid email or password. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void selectBranch(String branch) {
    selectedBranch.value = branch;
  }

  void navigateToRegister() {
    Get.snackbar(
      'Not available',
      'Signup is not supported in this app.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade800,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    // Do not dispose controllers here — keep them while app session is active.
    // Disposing here can cause `A TextEditingController was used after being disposed`
    // if UI tries to rebuild while the controller is still referenced.
    super.onClose();
  }
}
