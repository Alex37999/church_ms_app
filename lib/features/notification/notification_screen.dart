import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_pages.dart';
import '../widgets/bottom_nevigationbar.dart';
import './controllers/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 10,
                  16,
                  0,
                ),
                child: Row(
                  children: [
                    Material(
                      color: Colors.white,
                      elevation: 4,
                      shadowColor: const Color.fromRGBO(15, 23, 42, 0.08),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: _goToDashboard,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFF8FBFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE7ECF3)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(15, 23, 42, 0.06),
                            blurRadius: 24,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.unreadCount.value} new notifications',
                                  style: const TextStyle(
                                    color: Color(0xFF475569),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Stay updated with your latest church activity.',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (controller.unreadCount.value > 0)
                            TextButton(
                              onPressed: () async {
                                await controller.markAllRead();
                                if (controller.errorMessage.value.isEmpty) {
                                  Get.snackbar(
                                    'Notifications',
                                    'All marked read',
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    controller.errorMessage.value,
                                    backgroundColor: Colors.red.shade50,
                                  );
                                }
                              },
                              child: const Text('Mark all read'),
                            ),
                        ],
                      ),
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
                                : const Color(0xFFF7FAFF),
                            borderRadius: BorderRadius.circular(20),
                            elevation: notification.isRead ? 3 : 5,
                            shadowColor: const Color.fromRGBO(15, 23, 42, 0.08),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                await controller.markAsRead(notification.id);
                                if (controller.errorMessage.value.isEmpty) {
                                  Get.snackbar('Notification', 'Marked read');
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    controller.errorMessage.value,
                                    backgroundColor: Colors.red.shade50,
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: visual.bg,
                                        shape: BoxShape.circle,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              0.6,
                                            ),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        visual.icon,
                                        color: visual.fg,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        notification.isRead
                                                        ? FontWeight.w600
                                                        : FontWeight.w800,
                                                    fontSize: 14,
                                                    color: const Color(
                                                      0xFF0F172A,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (!notification.isRead) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 9,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF2563EB,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          999,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'NEW',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800,
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
                                              color: Color(0xFF334155),
                                              fontSize: 13,
                                              height: 1.35,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            notification.date,
                                            style: const TextStyle(
                                              color: Color(0xFF64748B),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
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
                      }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
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
    final canPop = Get.key.currentState?.canPop() ?? false;
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
