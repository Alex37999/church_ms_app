import 'dart:convert';

import 'package:dio/dio.dart' as dio;

import '../../../core/network/api_client.dart';
import 'edit_profile_model.dart';

class EditProfileRepository {
  final ApiClient _client = ApiClient();

  /// Calls POST /api/member/profile/update with multipart/form-data.
  /// If [imagePath] is provided the file will be uploaded as 'image'.
  Future<Data?> editProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    String? imagePath,
  }) async {
    try {
      final form = dio.FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });

      if (imagePath != null && imagePath.isNotEmpty) {
        final filename = imagePath.split('/').last;
        form.files.add(
          MapEntry(
            'image',
            await dio.MultipartFile.fromFile(imagePath, filename: filename),
          ),
        );
      }

      final res = await _client.post('/api/member/profile/update', data: form);

      try {
        print(
          '📥 [EditProfileRepository] raw update response: ${jsonEncode(res.data)}',
        );
      } catch (_) {}

      if (res.data == null) return null;
      final map = Map<String, dynamic>.from(res.data);
      final result = EditProfileGet.fromJson(map);
      return result.data;
    } catch (e) {
      print('❌ [EditProfileRepository] editProfile error: $e');
      return null;
    }
  }
}
