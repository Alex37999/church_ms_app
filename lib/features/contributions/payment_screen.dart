// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_mpesa_stk/flutter_mpesa_stk.dart';
// // import 'package:flutter_mpesa_stk/models/Mpesa.dart';
// //
// // // ─── CONFIG — replace these with your real credentials ───────────────────────
// // const String _consumerKey    = "YOUR_CONSUMER_KEY";
// // const String _consumerSecret = "YOUR_CONSUMER_SECRET";
// // const String _passKey        = "YOUR_PASS_KEY";
// // const String _shortcode      = "174379";          // Use 174379 for sandbox
// // const String _callbackUrl    = "https://your-backend.com/callback";
// // const String _environment    = "testing";         // "production" when going live
// // // ─────────────────────────────────────────────────────────────────────────────
// //
// //
// // /// Generates the Base64-encoded STK password required by Daraja API.
// // /// Formula: base64(Shortcode + Passkey + Timestamp)
// // String _generatePassword() {
// //   final timestamp = DateTime.now()
// //       .toIso8601String()
// //       .replaceAll(RegExp(r'[^0-9]'), '')
// //       .substring(0, 14); // YYYYMMDDHHmmss
// //   final raw = '$_shortcode$_passKey$timestamp';
// //   return base64.encode(utf8.encode(raw));
// // }
// //
// //
// // /// Initiates an M-Pesa STK Push request.
// // /// [phone]  — Customer phone in format 2547XXXXXXXX
// // /// [amount] — Whole number amount in KES (e.g. 100)
// // Future<bool> initiatePayment({
// //   required String phone,
// //   required int amount,
// //   String accountReference = "Order001",
// //   String transactionDesc  = "Payment",
// // }) async {
// //   try {
// //     final response = await FlutterMpesaSTK(
// //       _consumerKey,
// //       _consumerSecret,
// //       _generatePassword(),
// //       _shortcode,
// //       _callbackUrl,
// //       "Payment failed. Please try again.",
// //       env: _environment,
// //     ).stkPush(
// //       Mpesa(
// //         amount,
// //         phone,
// //         accountReference: accountReference,
// //         transactionDesc: transactionDesc,
// //       ),
// //     );
// //
// //     return response.status;
// //   } catch (e) {
// //     debugPrint("M-Pesa error: $e");
// //     return false;
// //   }
// // }
// //
// //
// // // ─── UI ───────────────────────────────────────────────────────────────────────
// //
// // class MpesaPaymentScreen extends StatefulWidget {
// //   const MpesaPaymentScreen({super.key});
// //
// //   @override
// //   State<MpesaPaymentScreen> createState() => _MpesaPaymentScreenState();
// // }
// //
// // class _MpesaPaymentScreenState extends State<MpesaPaymentScreen> {
// //   final _phoneCtrl  = TextEditingController();
// //   final _amountCtrl = TextEditingController();
// //   final _formKey    = GlobalKey<FormState>();
// //   bool _loading     = false;
// //
// //   @override
// //   void dispose() {
// //     _phoneCtrl.dispose();
// //     _amountCtrl.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _pay() async {
// //     if (!_formKey.currentState!.validate()) return;
// //
// //     setState(() => _loading = true);
// //
// //     final success = await initiatePayment(
// //       phone:  _phoneCtrl.text.trim(),
// //       amount: int.parse(_amountCtrl.text.trim()),
// //     );
// //
// //     if (!mounted) return;
// //     setState(() => _loading = false);
// //
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         backgroundColor: success ? const Color(0xFF00A651) : Colors.red,
// //         content: Text(
// //           success
// //               ? "✅ Check your phone for the M-Pesa PIN prompt"
// //               : "❌ Payment failed. Please try again.",
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Pay with M-Pesa"),
// //         backgroundColor: const Color(0xFF00A651),
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(24),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Phone field
// //               TextFormField(
// //                 controller: _phoneCtrl,
// //                 keyboardType: TextInputType.phone,
// //                 decoration: const InputDecoration(
// //                   labelText: "Phone Number",
// //                   hintText: "2547XXXXXXXX",
// //                   prefixIcon: Icon(Icons.phone),
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (v) {
// //                   if (v == null || v.isEmpty) return "Enter phone number";
// //                   if (!RegExp(r'^2547\d{8}$').hasMatch(v.trim())) {
// //                     return "Use format 2547XXXXXXXX";
// //                   }
// //                   return null;
// //                 },
// //               ),
// //
// //               const SizedBox(height: 16),
// //
// //               // Amount field
// //               TextFormField(
// //                 controller: _amountCtrl,
// //                 keyboardType: TextInputType.number,
// //                 decoration: const InputDecoration(
// //                   labelText: "Amount (KES)",
// //                   prefixIcon: Icon(Icons.money),
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (v) {
// //                   if (v == null || v.isEmpty) return "Enter amount";
// //                   final n = int.tryParse(v.trim());
// //                   if (n == null || n < 1) return "Enter a valid amount";
// //                   return null;
// //                 },
// //               ),
// //
// //               const SizedBox(height: 32),
// //
// //               // Pay button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: _loading ? null : _pay,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF00A651),
// //                     disabledBackgroundColor: Colors.grey.shade300,
// //                     foregroundColor: Colors.white,
// //                     padding: const EdgeInsets.symmetric(vertical: 14),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                   ),
// //                   child: _loading
// //                       ? const SizedBox(
// //                     height: 20,
// //                     width: 20,
// //                     child: CircularProgressIndicator(
// //                       color: Colors.white,
// //                       strokeWidth: 2,
// //                     ),
// //                   )
// //                       : const Text(
// //                     "Pay Now",
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // lib/screens/payment_screen.dart
// import 'package:flutter/material.dart';
//
// import 'm-pesa-service/mpesa_service_class.dart';
//
//
// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   final _mpesaService = MpesaService();
//   final _phoneController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _billRefController = TextEditingController();
//
//   bool _isLoading = false;
//   String _statusMessage = '';
//
//   Future<void> _makePayment() async {
//     setState(() {
//       _isLoading = true;
//       _statusMessage = '';
//     });
//
//     try {
//       final result = await _mpesaService.simulateC2BPayment(
//         shortCode: '600981',       // Your M-Pesa shortcode
//         msisdn: _phoneController.text.trim(),
//         amount: _amountController.text.trim(),
//         billRefNumber: _billRefController.text.trim(),
//       );
//
//       setState(() {
//         _statusMessage = '✅ Success: ${result['ResponseDescription']}';
//       });
//     } catch (e) {
//       setState(() {
//         _statusMessage = '❌ Error: $e';
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('M-Pesa C2B Payment')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number (254XXXXXXXXX)',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _amountController,
//               decoration: const InputDecoration(
//                 labelText: 'Amount (KES)',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _billRefController,
//               decoration: const InputDecoration(
//                 labelText: 'Bill Reference Number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _makePayment,
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('Pay with M-Pesa'),
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (_statusMessage.isNotEmpty)
//               Text(
//                 _statusMessage,
//                 style: TextStyle(
//                   color: _statusMessage.startsWith('✅')
//                       ? Colors.green
//                       : Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'm-pesa-service/mpesa_controller.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MpesaController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Pesa C2B Simulate'),
        backgroundColor: const Color(0xFF006400), // M-Pesa green
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Command ID dropdown ──────────────────────────────────────
              const Text('Command ID',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Obx(() => DropdownButtonFormField<String>(
                value: controller.commandId.value,
                decoration:  _inputDecoration('Select command'),
                items: controller.commandOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) controller.commandId.value = val;
                },
              )),

              const SizedBox(height: 16),

              // ── Short Code ───────────────────────────────────────────────
              const Text('Short Code',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.shortCodeController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('e.g. 600000'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Short code is required' : null,
              ),

              const SizedBox(height: 16),

              // ── Amount ───────────────────────────────────────────────────
              const Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('e.g. 100'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Amount is required' : null,
              ),

              const SizedBox(height: 16),

              // ── Phone Number (Msisdn) ────────────────────────────────────
              const Text('Phone Number (Msisdn)',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.msisdnController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('e.g. 254712345678'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Phone number is required';
                  if (!RegExp(r'^254\d{9}$').hasMatch(v)) {
                    return 'Enter a valid number starting with 254';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Bill Ref Number ──────────────────────────────────────────
              const Text('Bill Reference Number',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.billRefController,
                decoration: _inputDecoration('e.g. INV001 or account number'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Bill reference is required' : null,
              ),

              const SizedBox(height: 32),

              // ── Submit button ────────────────────────────────────────────
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.simulatePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.green.shade200,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Simulate Payment',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF006400)),
      ),
    );
  }
}