import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_pages.dart';
import '../widgets/bottom_nevigationbar.dart';
import '../widgets/app_header.dart';
import './controllers/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Obx(
        () => Column(
          children: [
            AppHeader(showBackButton: true, onBack: _goToDashboard),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${controller.unreadCount.value} new notifications',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 18),

                  if (controller.isLoading.value)
                    const Center(child: CircularProgressIndicator())
                  else if (controller.errorMessage.value.isNotEmpty)
                    Center(
                      child: Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )
                  else if (controller.notifications.isEmpty)
                    const Center(child: Text('No notifications'))
                  else
                    ...controller.notifications.map((notification) {
                      final visual = _visualFor(notification);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Material(
                          color: notification.isRead
                              ? Colors.white
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16),
                          elevation: 0.5,
                          shadowColor: Colors.black.withOpacity(0.04),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => controller.markAsRead(notification.id),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: visual.bg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      visual.icon,
                                      color: visual.fg,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notification.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight:
                                                      notification.isRead
                                                      ? FontWeight.w600
                                                      : FontWeight.w700,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            if (!notification.isRead) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF3B82F6,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Text(
                                                  'NEW',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          notification.message,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          notification.date,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _NotificationVisual _visualFor(NotificationModel n) {
    final title = n.title.toLowerCase();

    if (title.contains('event')) {
      return const _NotificationVisual(
        icon: Icons.notifications_none,
        bg: Color(0xFFEFF6FF),
        fg: Color(0xFF3B82F6),
      );
    }

    if (title.contains('birthday')) {
      return const _NotificationVisual(
        icon: Icons.card_giftcard,
        bg: Color(0xFFF5F3FF),
        fg: Color(0xFF8B5CF6),
      );
    }

    // Default success-style icon (contribution/receipt)
    return const _NotificationVisual(
      icon: Icons.check_circle_outline,
      bg: Color(0xFFEFFAF3),
      fg: Color(0xFF16A34A),
    );
  }

  void _goToDashboard() {
    final canPop = Get.key?.currentState?.canPop() ?? false;
    if (canPop) {
      Get.back();
      if (Get.isRegistered<BottomNavController>()) {
        // ensure dashboard tab is selected after returning
        Get.find<BottomNavController>().changeIndex(0);
      }
      return;
    }

    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().changeIndex(0);
    }
    Get.offAllNamed(Routes.HOME);
  }
}

class _NotificationVisual {
  final IconData icon;
  final Color bg;
  final Color fg;

  const _NotificationVisual({
    required this.icon,
    required this.bg,
    required this.fg,
  });
}
