import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './controllers/profile_controller.dart';
import '../widgets/app_header.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final ProfileController controller;
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController addressCtrl;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileController>();
    nameCtrl = TextEditingController(text: controller.username.value);
    emailCtrl = TextEditingController(text: controller.email.value);
    phoneCtrl = TextEditingController(text: controller.phoneNumber.value);
    addressCtrl = TextEditingController(text: controller.address.value);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  void _save() {
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

    controller.updateProfile(
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
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 12);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AppHeader(showBackButton: true, onBack: () => Get.back()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Update your personal information',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 20),

                // Avatar with initials
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B6FFF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5B6FFF).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              controller.getInitials(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Color(0xFF5B6FFF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap to change photo',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(),
                  ),
                ),
                spacing,
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                spacing,
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                spacing,
                TextField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Address / Branch',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),
                const SizedBox(height: 80),

                // Save Changes button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B6FFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
