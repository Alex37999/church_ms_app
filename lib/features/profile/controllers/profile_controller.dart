import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString username = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString address = ''.obs;
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
      username.value = 'John Doe';
      email.value = 'john.doe@example.com';
      phoneNumber.value = '+254712345678';
      address.value = 'Nairobi, Kenya';
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch profile: $e';
    } finally {
      isLoading.value = false;
    }
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
