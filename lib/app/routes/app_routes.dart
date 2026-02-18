part of 'app_pages.dart';

abstract class Routes {
  static const INITIAL = _Paths.HOME;
  static const HOME = _Paths.HOME;
  static const ANNOUNCEMENTS = _Paths.ANNOUNCEMENTS;
  static const CONTRIBUTIONS = _Paths.CONTRIBUTIONS;
  static const RECEIPTS = _Paths.RECEIPTS;
  static const PROFILE = _Paths.PROFILE;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
}

abstract class _Paths {
  static const HOME = '/home';
  static const ANNOUNCEMENTS = '/announcements';
  static const CONTRIBUTIONS = '/contributions';
  static const RECEIPTS = '/receipts';
  static const PROFILE = '/profile';
  static const NOTIFICATIONS = '/notifications';
}
