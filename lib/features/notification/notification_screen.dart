import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_header.dart';
import './controllers/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (controller.unreadCount.value > 0)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          '${controller.unreadCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (controller.isLoading.value)
                  const Center(child: CircularProgressIndicator())
                else if (controller.notifications.isEmpty)
                  const Center(child: Text('No notifications'))
                else
                  ...controller.notifications.map((notification) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: notification.isRead
                              ? Colors.white
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () => controller.markAsRead(notification.id),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(notification.message),
                          trailing: Text(
                            notification.date,
                            style: const TextStyle(fontSize: 12),
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
    );
  }
}
