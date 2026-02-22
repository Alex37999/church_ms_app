import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import 'reset_pass_controller.dart';
import 'package:churchmsapp/app/theme/app_theme.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Solid white background
          Container(color: Colors.white),

          // Main card
          SafeArea(
            child: Center(
              child: Obx(() {
                final t = Get.find<ThemeController>();
                final mq = MediaQuery.of(context);
                final cardWidth = min(380.0, mq.size.width * 0.90);

                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 28,
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
                      child: _ResetForm(),
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

class _ResetForm extends StatefulWidget {
  const _ResetForm({Key? key}) : super(key: key);

  @override
  State<_ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<_ResetForm> {
  late final controller = Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    final t = Get.find<ThemeController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
          "Reset Your Password",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: t.primaryText,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          "Enter your email to receive a reset link",
          style: TextStyle(color: t.secondaryText),
        ),

        const SizedBox(height: 22),

        Obx(
          () => _ResetInput(
            icon: Icons.email_outlined,
            hint: "Email Address",
            controller: controller.emailController,
            errorText: controller.emailError.value,
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.sendResetLink(),
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
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Send Reset Link",
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

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Remember your password?",
              style: TextStyle(color: t.secondaryText),
            ),
            TextButton(
              onPressed: controller.goBackToLogin,
              child: Text(
                "Back to login",
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

class _ResetInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final String? errorText;

  const _ResetInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
    this.errorText,
  }) : super(key: key);

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
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(icon, color: t.inputIconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.emailAddress,
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
