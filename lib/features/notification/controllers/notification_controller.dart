import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxList notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    isLoading.value = true;
    try {
      // Initialize with sample data
      notifications.value = [
        NotificationModel(
          id: '1',
          title: 'Contribution Received',
          message: 'Your contribution of KES 10,000 has been received.',
          date: '2026-02-15',
          isRead: false,
        ),
        NotificationModel(
          id: '2',
          title: 'Receipt Ready',
          message: 'Your monthly receipt is ready for download.',
          date: '2026-02-10',
          isRead: false,
        ),
        NotificationModel(
          id: '3',
          title: 'New Announcement',
          message: 'Sunday Service Time has been changed.',
          date: '2026-02-08',
          isRead: true,
        ),
      ];
      updateUnreadCount();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch notifications: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).toList().length;
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      updateUnreadCount();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String date;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.isRead,
  });
}
