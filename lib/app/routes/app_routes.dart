part of 'app_pages.dart';

abstract class Routes {
  static const INITIAL = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  // Signup and reset password routes removed
  static const ANNOUNCEMENTS = _Paths.ANNOUNCEMENTS;
  static const CONTRIBUTIONS = _Paths.CONTRIBUTIONS;
  static const RECEIPTS = _Paths.RECEIPTS;
  static const PROFILE = _Paths.PROFILE;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
  static const ACCOUNT_SETTINGS = _Paths.ACCOUNT_SETTINGS;
  static const ANNOUNCEMENTS_DETAILS = _Paths.ANNOUNCEMENTS_DETAILS;
}

abstract class _Paths {
  static const HOME = '/home';
  static const SPLASH = '/';
  static const LOGIN = '/login';
  // Signup and reset password paths removed
  static const ANNOUNCEMENTS = '/announcements';
  static const ANNOUNCEMENTS_DETAILS = '/announcements/:id';
  static const CONTRIBUTIONS = '/contributions';
  static const RECEIPTS = '/receipts';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/profile/edit';
  static const NOTIFICATIONS = '/notifications';
  static const ACCOUNT_SETTINGS = '/profile/account-settings';
}
