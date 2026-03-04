import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

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

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final client = ApiClient();
      final resp = await client.get('/api/member/notifications');
      final data = resp.data;

      if (data == null) {
        errorMessage.value = 'Empty response from server';
        return;
      }

      if (data is Map && data['success'] == true && data['data'] is List) {
        final List items = data['data'];

        final List<NotificationModel> mapped = items.map((item) {
          final id = item['id']?.toString() ?? '';
          final title = item['title']?.toString() ?? '';
          final message = item['message']?.toString() ?? '';
          final createdAtStr = item['created_at'] as String?;
          String dateStr = '';
          if (createdAtStr != null) {
            try {
              final dt = DateTime.parse(createdAtStr).toLocal();
              dateStr =
                  '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
            } catch (_) {}
          }
          final isRead = (item['is_read'] == true);

          return NotificationModel(
            id: id,
            title: title,
            message: message,
            date: dateStr,
            isRead: isRead,
          );
        }).toList();

        notifications.assignAll(mapped);
        // unread_count may be provided by API
        if (data['unread_count'] != null) {
          unreadCount.value = (data['unread_count'] as num).toInt();
        } else {
          updateUnreadCount();
        }

        errorMessage.value = '';
      } else {
        errorMessage.value = 'Failed to load notifications';
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch notifications: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final id = int.tryParse(notificationId);
      if (id == null) return;
      final client = ApiClient();
      await client.post('/api/member/notification/$id/mark-read');

      // Re-fetch latest notifications from server to ensure sync
      await fetchNotifications();
    } catch (e) {
      errorMessage.value = 'Failed to mark notification read: $e';
    }
  }

  Future<void> markAllRead() async {
    try {
      final client = ApiClient();
      await client.post('/api/member/notifications/mark-all-read');
      // Re-fetch to reflect server state
      await fetchNotifications();
    } catch (e) {
      errorMessage.value = 'Failed to mark all read: $e';
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
