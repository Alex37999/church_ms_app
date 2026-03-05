import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_pages.dart';
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

    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 14 * scale,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
          ),
        ),
        child: Row(
          children: [
            if (showBackButton) ...[
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                tooltip: 'Back',
              ),
              SizedBox(width: 4 * scale),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ChurchMS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        (Theme.of(context).textTheme.titleLarge?.fontSize ??
                            20) *
                        scale,
                  ),
                ),
                SizedBox(height: 4 * scale),
                Text(
                  'ChurchMS',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize:
                        (Theme.of(context).textTheme.bodySmall?.fontSize ??
                            12) *
                        scale,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // Always refresh notifications when user taps the bell.
                    if (Get.isRegistered<NotificationController>()) {
                      Get.find<NotificationController>().fetchNotifications();
                    }

                    if (Get.currentRoute != Routes.NOTIFICATIONS) {
                      Get.toNamed(Routes.NOTIFICATIONS);
                    }
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
                if (notificationCtrl != null)
                  Obx(() {
                    final unread = notificationCtrl.unreadCount.value;
                    if (unread <= 0) return const SizedBox.shrink();

                    return Positioned(
                      right: 8,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unread.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
