import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/routes/app_pages.dart';
import '../../app/theme/app_theme.dart';
import '../dashboard/controllers/home_controller.dart';
import '../notification/controllers/notification_controller.dart';

class AppHeader extends StatelessWidget {
  final double scale;
  final double horizontalPadding;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppHeader({
    this.scale = 1.0,
    this.horizontalPadding = 16.0,
    this.showBackButton = false,
    this.onBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final NotificationController? notificationCtrl =
        Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : null;
    final HomeController? homeCtrl = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;
    final topInset = MediaQuery.paddingOf(context).top;

    final hp = homeCtrl?.homepage.value?.data;

    final headerHeight = (194 * scale) + topInset;

    return Container(
      // Use a fixed height so AppHeader appears consistent across screens
      height: headerHeight,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topInset + (12 * scale),
        horizontalPadding,
        14 * scale,
      ),
      decoration: BoxDecoration(
        color: AppTheme.headerBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBackButton) ...[
                IconButton(
                  onPressed: onBack ?? Get.back,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  tooltip: 'Back',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 10 * scale),
              ],
              GestureDetector(
                onTap: () {
                  final scaffold = Scaffold.maybeOf(context);
                  if (scaffold != null) {
                    scaffold.openDrawer();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No drawer found')),
                    );
                  }
                },
                child: Container(
                  width: 44 * scale,
                  height: 44 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10 * scale),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6 * scale),
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHURCH SMARTLY',
                      style: GoogleFonts.poppins(
                        color: AppTheme.accentGreen,
                        fontSize: 12 * scale,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                      ),
                    ),
                    SizedBox(height: 2 * scale),
                    Text(
                      hp?.churchName ?? 'Grace Community Church',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (notificationCtrl != null) {
                    await notificationCtrl.fetchNotifications();
                  }

                  if (Get.currentRoute != Routes.NOTIFICATIONS) {
                    await Get.toNamed(Routes.NOTIFICATIONS);
                  }
                },
                tooltip: 'Notifications',
                icon: notificationCtrl != null
                    ? Obx(() {
                        final u = notificationCtrl.unreadCount.value;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 44 * scale,
                              height: 44 * scale,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.04),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.12),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                  size: 20 * scale,
                                ),
                              ),
                            ),
                            if (u > 0)
                              Positioned(
                                right: -6,
                                top: -6,
                                child: Container(
                                  padding: EdgeInsets.all(6 * (scale / 1.2)),
                                  decoration: BoxDecoration(
                                    color: AppTheme.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Text(
                                    u.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 10 * scale,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      })
                    : Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 44 * scale,
                            height: 44 * scale,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.12),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                                size: 20 * scale,
                              ),
                            ),
                          ),
                          if ((hp?.unreadNotifications ?? 0) > 0)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: Container(
                                padding: EdgeInsets.all(6 * (scale / 1.2)),
                                decoration: BoxDecoration(
                                  color: AppTheme.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.2,
                                  ),
                                ),
                                child: Text(
                                  (hp?.unreadNotifications ?? 0).toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 10 * scale,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
          SizedBox(height: 16 * scale),
          Text(
            'Welcome back 👋',
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 151, 153, 158),
              fontSize: 14 * scale,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4 * scale),
          Builder(
            builder: (context) {
              final storedName =
                  GetStorage().read<String>('user_full_name') ?? '';
              String toTitleCase(String s) {
                return s
                    .split(' ')
                    .map((word) {
                      if (word.isEmpty) return word;
                      final lower = word.toLowerCase();
                      return lower[0].toUpperCase() + lower.substring(1);
                    })
                    .join(' ');
              }

              final displayName = storedName.trim().isNotEmpty
                  ? toTitleCase(storedName.trim())
                  : 'Member Name';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26 * scale,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 6 * scale),
                  Text(
                    '${hp?.memberNumber ?? 'GCC-XXXX'}  •  ${hp?.branchName ?? 'Branch'}',
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 151, 153, 158),
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
