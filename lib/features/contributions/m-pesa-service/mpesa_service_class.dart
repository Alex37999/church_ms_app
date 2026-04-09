// // lib/services/mpesa_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class MpesaService {
//   static const String _baseUrl = 'https://sandbox.safaricom.co.ke';
//   static const String _consumerKey = 'mEvaTiHsks3JmzzO9kbh7v3dGTH7m9IZfg3Ez7Bp1Ah7rTfV';
//   static const String _consumerSecret = 'vjMiYzmU0OmKm7PgeyqTTGWtPouo3oROooh9khmyzPHaGm9dawAGu0Q6TAaDFlNA';
//
//   // Step 1: Generate OAuth Access Token
//   Future<String?> getAccessToken() async {
//     final credentials = base64Encode(
//       utf8.encode('$_consumerKey:$_consumerSecret'),
//     );
//
//     final response = await http.get(
//       Uri.parse('$_baseUrl/oauth/v1/generate?grant_type=client_credentials'),
//       headers: {
//         'Authorization': 'Basic $credentials',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['access_token'];
//     }
//
//     throw Exception('Failed to get access token: ${response.body}');
//   }
//
//   // Step 2: Simulate C2B Payment
//   Future<Map<String, dynamic>> simulateC2BPayment({
//     required String shortCode,
//     required String msisdn,      // Customer phone e.g. 254712345678
//     required String amount,
//     required String billRefNumber,
//   }) async {
//     final token = await getAccessToken();
//
//     final response = await http.post(
//       Uri.parse('$_baseUrl/mpesa/c2b/v1/simulate'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         "ShortCode": shortCode,
//         "CommandID": "CustomerPayBillOnline",
//         "Amount": amount,
//         "Msisdn": msisdn,
//         "BillRefNumber": billRefNumber,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     }
//
//     throw Exception('C2B Payment failed: ${response.body}');
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  // ─── Credentials (replace with your actual keys) ───────────────────────────
  static const String _consumerKey = 'mEvaTiHsks3JmzzO9kbh7v3dGTH7m9IZfg3Ez7Bp1Ah7rTfV';
  static const String _consumerSecret = 'vjMiYzmU0OmKm7PgeyqTTGWtPouo3oROooh9khmyzPHaGm9dawAGu0Q6TAaDFlNA';

  // ─── Base URLs ─────────────────────────────────────────────────────────────
  static const String _sandboxBaseUrl = 'https://sandbox.safaricom.co.ke';
  // static const String _productionBaseUrl = 'https://api.safaricom.co.ke';

  // Use sandbox for now — swap to production when going live
  static const String _baseUrl = _sandboxBaseUrl;

  // ─── Step 1: Generate OAuth Access Token ───────────────────────────────────
  // GET /oauth/v1/generate?grant_type=client_credentials
  // Auth: Basic Auth (consumerKey:consumerSecret base64 encoded)
  Future<String?> generateAccessToken() async {
    final credentials = base64Encode(
      utf8.encode('$_consumerKey:$_consumerSecret'),
    );

    final uri = Uri.parse(
      '$_baseUrl/oauth/v1/generate?grant_type=client_credentials',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['access_token'] as String?;
      } else {
        print('❌ [MpesaService] Token error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ [MpesaService] Token exception: $e');
      return null;
    }
  }

  // ─── Step 2: Simulate C2B Payment ──────────────────────────────────────────
  // POST /mpesa/c2b/v1/simulate
  // Auth: Bearer <access_token> (from Step 1)
  // Body: JSON
  Future<MpesaC2BResult> simulateC2BPayment({
    required String shortCode,
    required String commandId,   // 'CustomerPayBillOnline' or 'CustomerBuyGoodsOnline'
    required String amount,
    required String msisdn,      // Customer phone e.g. '254712345678'
    required String billRefNumber,
  }) async {
    // First get a fresh access token
    final token = await generateAccessToken();

    if (token == null) {
      return MpesaC2BResult.failure(
        message: 'Failed to generate access token. Check your credentials.',
      );
    }

    final uri = Uri.parse('$_baseUrl/mpesa/c2b/v1/simulate');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'ShortCode': shortCode,
          'CommandID': commandId,
          'Amount': amount,
          'Msisdn': msisdn,
          'BillRefNumber': billRefNumber,
        }),
      );

      final responseBody = jsonDecode(response.body);
      print('✅ [MpesaService] C2B response: $responseBody');

      if (response.statusCode == 200) {

        print('═══════════════════════════════');
        print('✅ M-PESA C2B SUCCESS');
        print('📍 Endpoint: ${uri.toString()}');
        print('💰 Amount: $amount');
        print('📱 Phone: $msisdn');
        print('🔖 Ref: $billRefNumber');
        print('📦 Response: $responseBody');
        print('═══════════════════════════════');


        return MpesaC2BResult.success(
          message: responseBody['CustomerMessage'] ??
              responseBody['ResponseDescription'] ??
              'Payment simulated successfully.',
          data: responseBody,
        );
      } else {
        return MpesaC2BResult.failure(
          message: responseBody['errorMessage'] ??
              responseBody['ResponseDescription'] ??
              'Payment simulation failed.',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ [MpesaService] C2B exception: $e');
      return MpesaC2BResult.failure(message: 'Network error: $e');
    }
  }
}

// ─── Result model ─────────────────────────────────────────────────────────────
class MpesaC2BResult {
  final bool isSuccess;
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  MpesaC2BResult._({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory MpesaC2BResult.success({
    required String message,
    Map<String, dynamic>? data,
  }) {
    return MpesaC2BResult._(
      isSuccess: true,
      message: message,
      statusCode: 200,
      data: data,
    );
  }

  factory MpesaC2BResult.failure({
    required String message,
    int statusCode = 0,
  }) {
    return MpesaC2BResult._(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
    );
  }
}