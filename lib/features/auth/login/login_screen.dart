import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/theme_controller.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final headerHeight = min(300.0, mq.size.height * 0.36);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top header with decorative circles
            Container(
              height: headerHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0F2A4A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // left teal circle
                  Positioned(
                    left: -40,
                    bottom: 18,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF16A34A).withOpacity(0.12),
                      ),
                    ),
                  ),
                  // right subtle dark circle
                  Positioned(
                    right: -60,
                    top: -40,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.03),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // small logo bubble
                          Container(
                            width: 66,
                            height: 66,
                            decoration: BoxDecoration(
                              color: Color(0xFF0F2A4A).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Center(
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Image.asset(
                                    'assets/icon/app_icon.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Brand title
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: 'Church',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'Smartly',
                                  style: TextStyle(color: Color(0xFF16A34A)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome back to your church community',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Obx(() {
                final t = Get.find<ThemeController>();
                final cardWidth = min(520.0, mq.size.width - 32);

                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: t.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: _LoginForm(),
                );
              }),
            ),
            // site text outside the card
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  'churchsmartly.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.find<ThemeController>().secondaryText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// INPUT WIDGET
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
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
            if (errorText != null && errorText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 6.0),
                child: Text(
                  errorText!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            // validation UI removed — error messages are handled elsewhere
          ],
        );
      },
    );
  }
}

// Preserved login form as a StatefulWidget so internal TextFormField states
// survive parent theme-triggered rebuilds and navigation transitions.
class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  late final controller = Get.find<LoginController>();

  Future<void> _showBranchPicker(
    BuildContext context,
    LoginController ctrl,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: ctrl.branches.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final branch = ctrl.branches[index];
                      final selected = ctrl.selectedBranch.value == branch;
                      return ListTile(
                        title: Text(
                          branch,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: selected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          ctrl.selectBranch(branch);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Get.find<ThemeController>();

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign In',
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF0F2A4A),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your details to continue',
            style: TextStyle(color: t.secondaryText),
          ),
          const SizedBox(height: 18),

          Obx(
            () => _CustomInput(
              icon: Icons.email_outlined,
              hint: 'Email or Mobile Number',
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

          // Branch selector (custom modal)
          GetX<LoginController>(
            builder: (c) {
              final selected = c.selectedBranch.value;
              return GestureDetector(
                onTap: () => _showBranchPicker(context, controller),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: t.inputFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: t.inputIconColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selected.isEmpty ? 'Select your Branch' : selected,
                          style: TextStyle(
                            color: selected.isEmpty
                                ? t.secondaryText
                                : t.primaryText,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: (v) => controller.rememberMe.value = v!,
                ),
              ),
              Text('Remember me', style: TextStyle(color: t.secondaryText)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.login(formKey: controller.formKey),
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: Color(0xFF0F2A4A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: t.secondaryText.withOpacity(0.4),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Secure & Encrypted',
                    style: TextStyle(fontSize: 12, color: t.secondaryText),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: t.secondaryText.withOpacity(0.4),
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // const SizedBox(height: 14),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "Don't have an account?",
          //       style: TextStyle(color: t.secondaryText),
          //     ),
          //     SizedBox.shrink(),
          //   ],
          // ),
        ],
      ),
    );
  }
}
