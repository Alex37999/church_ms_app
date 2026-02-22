import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:churchmsapp/app/routes/app_pages.dart';
import 'package:churchmsapp/core/services/storage_service.dart';
import '../widgets/app_header.dart';
import './controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppHeader(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'View and manage your information',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 32),
                if (controller.isLoading.value)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    children: [
                      // Profile Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Avatar Circle
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFF5B6FFF),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF5B6FFF,
                                    ).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  controller.getInitials(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Name and Member No
                            Text(
                              controller.username.value,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Member No: ${controller.memberNo.value}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Divider
                            Container(height: 1, color: Colors.grey.shade200),
                            const SizedBox(height: 20),

                            // Contact Information with Icons
                            _InfoItem(
                              icon: Icons.email_outlined,
                              label: controller.email.value,
                            ),
                            const SizedBox(height: 14),
                            _InfoItem(
                              icon: Icons.phone_outlined,
                              label: controller.phoneNumber.value,
                            ),
                            const SizedBox(height: 14),
                            _InfoItem(
                              icon: Icons.location_on_outlined,
                              label: controller.address.value,
                            ),
                            const SizedBox(height: 14),
                            _InfoItem(
                              icon: Icons.calendar_today_outlined,
                              label:
                                  'Member since ${controller.memberSince.value}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Menu Items
                      _MenuItemTile(
                        icon: Icons.edit_outlined,
                        title: 'Edit Profile',
                        onTap: () {
                          // TODO: Navigate to edit profile
                        },
                      ),
                      const SizedBox(height: 12),
                      _MenuItemTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        onTap: () {
                          // TODO: Navigate to change password
                        },
                      ),
                      const SizedBox(height: 12),
                      _MenuItemTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notification Preferences',
                        onTap: () {
                          // TODO: Navigate to notification preferences
                        },
                      ),
                      const SizedBox(height: 12),
                      _MenuItemTile(
                        icon: Icons.settings_outlined,
                        title: 'Account Settings',
                        onTap: () {
                          // TODO: Navigate to account settings
                        },
                      ),
                      const SizedBox(height: 18),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Clear stored session and navigate to login
                            final storage = Get.find<StorageService>();
                            await storage.setLoggedIn(false);
                            await storage.saveToken('');
                            await storage.saveUserId('');
                            await storage.saveUserEmail('');
                            await storage.saveUserFullName('');
                            Get.offAllNamed(Routes.LOGIN);
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItemTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
