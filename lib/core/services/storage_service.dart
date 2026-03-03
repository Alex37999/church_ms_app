import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static const _kTokenKey = 'auth_token';
  static const _kUserIdKey = 'user_id';
  static const _kUserEmailKey = 'user_email';
  static const _kFullNameKey = 'user_full_name';
  static const _kLoggedInKey = 'logged_in';

  late final GetStorage _box;

  Future<void> init() async {
    _box = GetStorage();
  }

  Future<void> saveToken(String token) async {
    await _box.write(_kTokenKey, token);
  }

  Future<String?> getToken() async {
    return _box.read<String>(_kTokenKey);
  }

  Future<void> saveUserId(String id) async {
    await _box.write(_kUserIdKey, id);
  }

  Future<void> saveUserEmail(String email) async {
    await _box.write(_kUserEmailKey, email);
  }

  Future<void> saveUserFullName(String name) async {
    await _box.write(_kFullNameKey, name);
  }

  Future<void> setLoggedIn(bool value) async {
    await _box.write(_kLoggedInKey, value);
  }

  Future<bool> isLoggedIn() async => _box.read<bool>(_kLoggedInKey) ?? false;

  /// Clear stored session data (token and user info).
  Future<void> clearSession() async {
    await _box.remove(_kTokenKey);
    await _box.remove(_kUserIdKey);
    await _box.remove(_kUserEmailKey);
    await _box.remove(_kFullNameKey);
    await _box.write(_kLoggedInKey, false);
  }
}
