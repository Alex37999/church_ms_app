import 'package:get/get.dart';

class StorageService extends GetxService {
  Future<void> init() async {}

  Future<void> saveToken(String token) async {}
  Future<void> saveUserId(String id) async {}
  Future<void> saveUserEmail(String email) async {}
  Future<void> saveUserFullName(String name) async {}
  Future<void> setLoggedIn(bool value) async {}
  Future<bool> isLoggedIn() async => false;
}
