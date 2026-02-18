import 'package:get/get.dart';

class AnnouncementsController extends GetxController {
  final RxList<AnnouncementModel> announcements = <AnnouncementModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  void fetchAnnouncements() {
    isLoading.value = true;
    try {
      // Initialize with sample data
      announcements.assignAll([
        AnnouncementModel(
          title: 'Sunday Service Time Cha...',
          description:
              'Starting next week, Sunday service will begin at 9:00 AM instead of 10:00...',
          source: 'Church Admin',
          date: '2026-02-15',
          isNew: true,
        ),
        AnnouncementModel(
          title: 'Youth Camp Registration...',
          description:
              'Registration for the annual youth camp is now open. Limited slots available...',
          source: 'Youth Department',
          date: '2026-02-10',
          isNew: true,
        ),
        AnnouncementModel(
          title: 'Monthly Prayer Meeting',
          description:
              'Join us for our monthly prayer meeting this Friday at 6:00 PM...',
          source: 'Prayer Team',
          date: '2026-02-05',
          isNew: false,
        ),
        AnnouncementModel(
          title: 'Building Fund Update',
          description:
              'We are excited to share that we have reached 75% of our building fund...',
          source: 'Finance Team',
          date: '2026-02-01',
          isNew: false,
        ),
      ]);
      errorMessage.value = '';
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
