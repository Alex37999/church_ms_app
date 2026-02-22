import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import 'signup_controller.dart';
import 'package:churchmsapp/app/theme/app_theme.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Solid white background
          Container(color: Colors.white),

          // Main content: centered register card
          SafeArea(
            child: Center(
              child: Obx(() {
                final t = Get.find<ThemeController>();
                final mq = MediaQuery.of(context);
                final cardWidth = min(360.0, mq.size.width * 0.90);

                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: t.cardColor,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: mq.size.height - 120,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _RegisterForm(),
                    ),
                  ),
                );
              }),
            ),
          ),

          // (theme toggle removed; single-color app)
        ],
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  late final controller = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    final t = Get.find<ThemeController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 6),
        Text(
          "Studymora",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: t.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Join our community today',
          style: TextStyle(color: t.secondaryText),
        ),
        const SizedBox(height: 18),

        Obx(
          () => _CustomInput(
            icon: Icons.person_outline,
            hint: 'Full Name',
            controller: controller.fullNameController,
            errorText: controller.nameError.value,
          ),
        ),

        const SizedBox(height: 12),

        Obx(
          () => _CustomInput(
            icon: Icons.email_outlined,
            hint: 'Email Address',
            controller: controller.emailController,
            errorText: controller.emailError.value,
          ),
        ),

        const SizedBox(height: 12),

        Obx(
          () => _CustomInput(
            icon: Icons.lock_outline,
            hint: 'Password',
            controller: controller.passwordController,
            obscure: controller.obscurePassword.value,
            toggleObscure: controller.togglePasswordVisibility,
            errorText: controller.passwordError.value,
          ),
        ),

        const SizedBox(height: 12),

        Obx(
          () => _CustomInput(
            icon: Icons.lock_outline,
            hint: 'Confirm Password',
            controller: controller.confirmPasswordController,
            obscure: controller.obscureConfirmPassword.value,
            toggleObscure: controller.toggleConfirmPasswordVisibility,
            errorText: controller.confirmPasswordError.value,
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.register(),
              style: ElevatedButton.styleFrom(
                elevation: 6,
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person_add, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(color: t.secondaryText),
            ),
            TextButton(
              onPressed: controller.navigateToLogin,
              child: Text(
                'Sign in here',
                style: TextStyle(
                  color: Color.lerp(AppTheme.primaryColor, Colors.black, 0.18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Reusable input used same as login style
class _CustomInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextEditingController controller;
  final String? errorText;
  final VoidCallback? toggleObscure;

  const _CustomInput({
    required this.icon,
    required this.hint,
    required this.controller,
    this.errorText,
    this.obscure = false,
    this.toggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (t) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: t.inputFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.18)),
              ),
              child: Row(
                children: [
                  Icon(icon, color: t.inputIconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      obscureText: obscure,
                      style: TextStyle(color: t.primaryText),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(color: t.secondaryText),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  if (toggleObscure != null)
                    IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                        color: t.inputIconColor,
                      ),
                      onPressed: toggleObscure,
                    ),
                ],
              ),
            ),
            // Error message below the text field (শুধু লাল টেক্সট)
            if (errorText != null && errorText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
