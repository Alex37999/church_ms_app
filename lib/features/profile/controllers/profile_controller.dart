import 'package:get/get.dart';

import '../data/profile_repository.dart';
import '../data/profile_model.dart';

class ProfileController extends GetxController {
  final RxString username = ''.obs;
  final RxString memberNo = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString address = ''.obs;
  final RxString imageUrl = ''.obs;
  final RxString memberSince = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  final ProfileRepository _repo = ProfileRepository();

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final Data? data = await _repo.fetchProfile();
      if (data == null) {
        errorMessage.value = 'Failed to load profile';
        return;
      }

      username.value = data.name ?? '';
      imageUrl.value = data.image ?? '';
      // Prefer explicit member number, fallback to id if null
      memberNo.value =
          (data.memberNumber != null && data.memberNumber.toString().isNotEmpty)
          ? data.memberNumber.toString()
          : (data.id?.toString() ?? '');
      email.value = data.email ?? '';
      phoneNumber.value = data.phone ?? '';
      address.value = data.address ?? data.branch?.name ?? '';
      memberSince.value = _formatJoinDate(data.joinDate);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch profile: $e';
    } finally {
      isLoading.value = false;
    }
  }

  String _formatJoinDate(DateTime? date) {
    if (date == null) return '';
    final d = date.toLocal();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final month = months[d.month - 1];
    return '$month ${d.day}, ${d.year}';
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
    String? newImageUrl,
  }) {
    if (newUsername != null) username.value = newUsername;
    if (newEmail != null) email.value = newEmail;
    if (newPhone != null) phoneNumber.value = newPhone;
    if (newAddress != null) address.value = newAddress;
    if (newImageUrl != null) imageUrl.value = newImageUrl;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
