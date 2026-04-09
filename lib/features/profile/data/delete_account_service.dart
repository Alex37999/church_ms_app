import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteAccountService {
  //final String baseUrl;
  final String baseUrl= "https://churchsmartly.com";
  final String token;

  //DeleteAccountService({required this.baseUrl, required this.token});
  DeleteAccountService({ required this.token});

  /// Deletes the member account.
  /// Requires [confirmation] to be exactly "DELETE".
  /// Returns a [DeleteAccountResult] with success or error info.
  Future<DeleteAccountResult> deleteAccount({
    String confirmation = 'DELETE',
  }) async {
    final uri = Uri.parse('$baseUrl/api/member/account/delete');

    try {
      final request = http.MultipartRequest('POST', uri);

      // Headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Body (form-data)
      request.fields['confirmation'] = confirmation;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteAccountResult.success(
          message: responseBody['message'] ?? 'Account deleted successfully.',
        );
      } else if (response.statusCode == 422) {
        // Validation error — confirmation field missing or wrong
        final errors = responseBody['errors'] as Map<String, dynamic>?;
        final errorMessage = errors?.values.first?.first as String? ??
            responseBody['message'] ??
            'Confirmation is missing or invalid.';
        return DeleteAccountResult.failure(
          statusCode: response.statusCode,
          message: errorMessage,
        );
      } else {
        return DeleteAccountResult.failure(
          statusCode: response.statusCode,
          message: responseBody['message'] ?? 'An unexpected error occurred.',
        );
      }
    } catch (e) {
      return DeleteAccountResult.failure(
        statusCode: 0,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}

class DeleteAccountResult {
  final bool isSuccess;
  final String message;
  final int statusCode;

  DeleteAccountResult._({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
  });

  factory DeleteAccountResult.success({required String message}) {
    return DeleteAccountResult._(
      isSuccess: true,
      message: message,
      statusCode: 200,
    );
  }

  factory DeleteAccountResult.failure({
    required int statusCode,
    required String message,
  }) {
    return DeleteAccountResult._(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
    );
  }
}