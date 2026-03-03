import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../data/auth_repository.dart';
import 'package:churchmsapp/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

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

      // Development fallback: if auth repo is a stub and returns null,
      // treat as successful login so tapping the login button navigates to Home.
      if (loginResponse == null) {
        await Get.find<StorageService>().setLoggedIn(true);
        Get.snackbar(
          'Success 🎉',
          'Login (dev) — navigating to Home',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );

        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed(Routes.HOME);
        return;
      }

      //===Success check=============//
      if (loginResponse != null &&
          loginResponse.success == true &&
          loginResponse.data?.accessToken?.isNotEmpty == true) {
        print('🔍 DEBUG LOGIN: loginResponse.data = ${loginResponse.data}');
        print('🔍 DEBUG LOGIN: user object = ${loginResponse.data?.user}');
        print('🔍 DEBUG LOGIN: user.name = ${loginResponse.data?.user?.name}');
        print('🔍 DEBUG LOGIN: user.id = ${loginResponse.data?.user?.id}');

        // Token Save
        await Get.find<StorageService>().saveToken(
          loginResponse.data!.accessToken!,
        );

        // Save User ID and Full Name
        if (loginResponse.data?.user?.id != null) {
          await Get.find<StorageService>().saveUserId(
            loginResponse.data!.user!.id.toString(),
          );
        }
        if (loginResponse.data?.user?.name != null) {
          final fullName = loginResponse.data!.user!.name!;
          print('🔍 DEBUG LOGIN: About to save fullName = "$fullName"');
          await Get.find<StorageService>().saveUserFullName(fullName);
          print('🔍 DEBUG LOGIN: Saved fullName successfully');
        } else {
          print('⚠️ DEBUG LOGIN: user.name is null!');
        }

        // Set logged in state
        await Get.find<StorageService>().setLoggedIn(true);

        // Success Snackbar
        Get.snackbar(
          'Success 🎉',
          'Login Successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(10),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        await Future.delayed(const Duration(milliseconds: 300));

        Get.offAllNamed(Routes.HOME);
      } else {
        String errorMessage = 'Invalid email or password. Please try again.';

        if (loginResponse?.message != null &&
            loginResponse!.message!.isNotEmpty) {
          errorMessage = loginResponse.message!;
        }

        Get.snackbar(
          'Login Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 12,
        );
      }
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
