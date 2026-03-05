import 'package:get/get.dart';
import '../../announcements/bindings/announcements_binding.dart';
import '../../contributions/bindings/contributions_binding.dart';
import '../../notification/bindings/notification_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../receipts/bindings/receipts_binding.dart';
import '../../event/binding/event_binding.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Home controller
    Get.lazyPut<HomeController>(() => HomeController());

    // Initialize all feature controllers used in HomePage
    AnnouncementsBinding().dependencies();
    ContributionsBinding().dependencies();
    ReceiptsBinding().dependencies();
    EventBinding().dependencies();
    ProfileBinding().dependencies();
    NotificationBinding().dependencies();
  }
}
