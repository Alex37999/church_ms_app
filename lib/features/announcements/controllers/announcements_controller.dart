import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
// import 'dart:convert'; // Removed unused import

class AnnouncementsController extends GetxController {
  final RxList<AnnouncementModel> announcements = <AnnouncementModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  void fetchAnnouncements() async {
    isLoading.value = true;
    try {
      final client = ApiClient();
      final resp = await client.get('/api/member/announcements');
      final data = resp.data;

      if (data == null) {
        errorMessage.value = 'Empty response from server';
        return;
      }

      if (data is Map && data['success'] == true && data['data'] is List) {
        final List items = data['data'];
        final now = DateTime.now();
        final List<AnnouncementModel> mapped = items.map((item) {
          final createdAtStr = item['created_at'] as String?;
          DateTime? createdAt;
          String dateStr = '';
          if (createdAtStr != null) {
            try {
              createdAt = DateTime.parse(createdAtStr).toLocal();
              dateStr =
                  '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
            } catch (_) {}
          }

          final isNew = createdAt != null
              ? now.difference(createdAt).inDays <= 7
              : false;

          return AnnouncementModel(
            title: item['title']?.toString() ?? '',
            description: item['message']?.toString() ?? '',
            source: (item['priority']?.toString() ?? '').toUpperCase(),
            date: dateStr,
            isNew: isNew,
          );
        }).toList();

        announcements.assignAll(mapped);
        errorMessage.value = '';
      } else {
        errorMessage.value = 'Failed to load announcements';
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch announcements: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class AnnouncementModel {
  final String title;
  final String description;
  final String source;
  final String date;
  final bool isNew;

  AnnouncementModel({
    required this.title,
    required this.description,
    required this.source,
    required this.date,
    required this.isNew,
  });
}
