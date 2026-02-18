import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
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
      notifications.assignAll([
        NotificationModel(
          id: '1',
          title: 'Contribution Confirmed',
          message: 'Your tithe of KES 10,000 has been recorded successfully',
          date: '2 hours ago',
          isRead: false,
        ),
        NotificationModel(
          id: '2',
          title: 'Event Reminder',
          message: 'Youth Camp registration closes in 3 days',
          date: '5 hours ago',
          isRead: false,
        ),
        NotificationModel(
          id: '3',
          title: 'Birthday Wishes',
          message: 'Happy Birthday! May God bless you abundantly',
          date: '1 day ago',
          isRead: false,
        ),
        NotificationModel(
          id: '4',
          title: 'Receipt Available',
          message: 'Your January receipt is ready to download',
          date: '3 days ago',
          isRead: true,
        ),
      ]);
      updateUnreadCount();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch notifications: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
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
