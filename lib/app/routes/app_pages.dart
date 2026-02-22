import 'package:get/get.dart';
import '../../features/announcements/bindings/announcements_binding.dart';
import '../../features/announcements/announcements_screen.dart';
import '../../features/contributions/bindings/contributions_binding.dart';
import '../../features/contributions/contributions_screen.dart';
import '../../features/dashboard/bindings/home_binding.dart';
import '../../features/dashboard/home_page.dart';
import '../../features/notification/bindings/notification_binding.dart';
import '../../features/notification/notification_screen.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/receipts/bindings/receipts_binding.dart';
import '../../features/receipts/receipts_screen.dart';
import '../../features/auth/login/login_binding.dart';
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/signup/signup_binding.dart';
import '../../features/auth/signup/signup_screen.dart';
import '../../features/auth/reset_pass/reset_pass_binding.dart';
import '../../features/auth/reset_pass/reset_pass_screen.dart';
import '../../features/splash/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Splash (entry) page
    GetPage(name: _Paths.SPLASH, page: () => const SplashScreen()),
    // Authentication pages
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ANNOUNCEMENTS,
      page: () => const AnnouncementsScreen(),
      binding: AnnouncementsBinding(),
    ),
    GetPage(
      name: _Paths.CONTRIBUTIONS,
      page: () => ContributionsScreen(),
      binding: ContributionsBinding(),
    ),
    GetPage(
      name: _Paths.RECEIPTS,
      page: () => const ReceiptsScreen(),
      binding: ReceiptsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
  ];
}
