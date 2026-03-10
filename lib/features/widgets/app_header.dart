import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_pages.dart';
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

    Widget buildHeader() {
      final hp = homeCtrl?.homepage.value?.data;
      final unread =
          notificationCtrl?.unreadCount.value ?? hp?.unreadNotifications ?? 0;

      return Container(
        constraints: BoxConstraints(minHeight: (194 * scale) + topInset),
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topInset + (12 * scale),
          horizontalPadding,
          14 * scale,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0B2A53),
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
                Container(
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
                SizedBox(width: 12 * scale),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHURCH SMARTLY',
                        style: TextStyle(
                          color: const Color(0xFF98C6FF),
                          fontSize: 10 * scale,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                      SizedBox(height: 2 * scale),
                      Text(
                        hp?.churchName ?? 'Grace Community Church',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13 * scale,
                          fontWeight: FontWeight.bold,
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
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications_none, color: Colors.white),
                      if (unread > 0)
                        Positioned(
                          right: -2,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF0B2A53),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              unread.toString(),
                              style: const TextStyle(
                                fontSize: 10,
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
              style: TextStyle(
                color: const Color(0xFFBFD8FF),
                fontSize: 12 * scale,
              ),
            ),
            SizedBox(height: 4 * scale),
            Text(
              'Member No: ${hp?.memberNumber ?? 'GCC-XXXX'}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 * scale,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4 * scale),
            Text(
              hp?.branchName ?? 'Branch',
              style: TextStyle(
                color: const Color(0xFFBFD8FF),
                fontSize: 11 * scale,
              ),
            ),
          ],
        ),
      );
    }

    if (homeCtrl != null || notificationCtrl != null) {
      return Obx(buildHeader);
    }

    return buildHeader();
  }
}
