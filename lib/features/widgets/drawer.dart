import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_pages.dart';
import '../../core/services/storage_service.dart';
import '../../features/auth/data/auth_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_nevigationbar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Future<void> _goToHomeWithIndex(int index) async {
    // If already on HOME, just change index
    if (Get.currentRoute == Routes.HOME) {
      if (Get.isRegistered<BottomNavController>()) {
        Get.find<BottomNavController>().changeIndex(index);
      }
      Get.back();
      return;
    }

    // Navigate to home then set index after a short delay to ensure bindings ran
    await Get.offAllNamed(Routes.HOME);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().changeIndex(index);
    }
  }

  Future<void> _logout(BuildContext context) async {
    final repo = AuthRepository();
    final storage = Get.isRegistered<StorageService>()
        ? Get.find<StorageService>()
        : null;

    // Attempt API logout but proceed regardless
    final ok = await repo.logout();
    try {
      // Clear local session
      if (storage != null) await storage.clearSession();
    } catch (_) {}

    // Navigate to login
    await Get.offAllNamed(Routes.LOGIN);
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.primary;

    return Drawer(
      child: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                color: const Color(0xFF0F2A4A),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icon/app_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Church Smartly',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Welcome',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Main',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Navigation tiles (match bottom nav indexes)
              ListTile(
                leading: Icon(Icons.home_outlined, color: iconColor),
                title: Text(
                  'Home',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.black26),
                visualDensity: VisualDensity.compact,
                onTap: () async {
                  Navigator.pop(context);
                  await _goToHomeWithIndex(0);
                },
              ),
              const Divider(indent: 72, height: 1),
              ListTile(
                leading: Icon(Icons.attach_money_outlined, color: iconColor),
                title: Text(
                  'Giving',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.black26),
                visualDensity: VisualDensity.compact,
                onTap: () async {
                  Navigator.pop(context);
                  await _goToHomeWithIndex(1);
                },
              ),
              const Divider(indent: 72, height: 1),
              ListTile(
                leading: Icon(Icons.receipt_long_outlined, color: iconColor),
                title: Text(
                  'Receipts',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.black26),
                visualDensity: VisualDensity.compact,
                onTap: () async {
                  Navigator.pop(context);
                  await _goToHomeWithIndex(2);
                },
              ),

              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Events & Announcements',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ListTile(
                leading: Icon(Icons.event_outlined, color: iconColor),
                title: Text(
                  'Events',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.black26),
                visualDensity: VisualDensity.compact,
                onTap: () async {
                  Navigator.pop(context);
                  await _goToHomeWithIndex(3);
                },
              ),
              const Divider(indent: 72, height: 1),
              ListTile(
                leading: Icon(Icons.notifications_none, color: iconColor),
                title: Text(
                  'Announcements',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.black26),
                visualDensity: VisualDensity.compact,
                onTap: () async {
                  Navigator.pop(context);
                  await _goToHomeWithIndex(4);
                },
              ),

              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Account',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ListTile(
                leading: Icon(Icons.person_outline, color: iconColor),
                title: Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.black26),
                visualDensity: VisualDensity.compact,
                onTap: () async {
                  Navigator.pop(context);
                  await _goToHomeWithIndex(5);
                },
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _logout(context);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
