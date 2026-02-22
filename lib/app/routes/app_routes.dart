part of 'app_pages.dart';

abstract class Routes {
  static const INITIAL = _Paths.HOME;
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
  static const ANNOUNCEMENTS = _Paths.ANNOUNCEMENTS;
  static const CONTRIBUTIONS = _Paths.CONTRIBUTIONS;
  static const RECEIPTS = _Paths.RECEIPTS;
  static const PROFILE = _Paths.PROFILE;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
}

abstract class _Paths {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const RESET_PASSWORD = '/reset-password';
  static const ANNOUNCEMENTS = '/announcements';
  static const CONTRIBUTIONS = '/contributions';
  static const RECEIPTS = '/receipts';
  static const PROFILE = '/profile';
  static const NOTIFICATIONS = '/notifications';
}
