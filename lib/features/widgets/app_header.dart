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

    Widget buildHeader() {
      final hp = homeCtrl?.homepage.value?.data;
      final unread =
          notificationCtrl?.unreadCount.value ?? hp?.unreadNotifications ?? 0;

      return SafeArea(
        top: true,
        bottom: false,
        child: Container(
          constraints: BoxConstraints(minHeight: 260 * scale),
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            76 * scale,
            horizontalPadding,
            12 * scale,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF0B2A53),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
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
                    width: 56 * scale,
                    height: 56 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12 * scale),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8 * scale),
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 10 * scale),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHURCH SMARTLY',
                          style: TextStyle(
                            color: const Color(0xFF98C6FF),
                            fontSize: 11 * scale,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2 * scale),
                        Text(
                          hp?.churchName ?? 'Grace Community Church',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14 * scale,
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
                        const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
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
              SizedBox(height: 18 * scale),
              Text(
                'Welcome back',
                style: TextStyle(
                  color: const Color(0xFFBFD8FF),
                  fontSize: 13 * scale,
                ),
              ),
              SizedBox(height: 6 * scale),
              Text(
                'Member No: ${hp?.memberNumber ?? 'GCC-XXXX'}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6 * scale),
              Text(
                hp?.branchName ?? 'Branch',
                style: TextStyle(
                  color: const Color(0xFFBFD8FF),
                  fontSize: 12 * scale,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (homeCtrl != null || notificationCtrl != null) {
      return Obx(buildHeader);
    }

    return buildHeader();
  }
}
