import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString username = ''.obs;
  final RxString memberNo = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString address = ''.obs;
  final RxString memberSince = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() {
    isLoading.value = true;
    try {
      // Initialize with sample data
      username.value = 'David Otieno';
      memberNo.value = 'GCC-1024';
      email.value = 'david.otieno@email.com';
      phoneNumber.value = '+254 712 345 678';
      address.value = 'Westside Branch';
      memberSince.value = 'January 2024';
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch profile: $e';
    } finally {
      isLoading.value = false;
    }
  }

  String getInitials() {
    final names = username.value.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return username.value.isNotEmpty ? username.value[0].toUpperCase() : '';
  }

  void updateProfile({
    String? newUsername,
    String? newEmail,
    String? newPhone,
    String? newAddress,
  }) {
    if (newUsername != null) username.value = newUsername;
    if (newEmail != null) email.value = newEmail;
    if (newPhone != null) phoneNumber.value = newPhone;
    if (newAddress != null) address.value = newAddress;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
