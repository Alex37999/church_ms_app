// import 'package:flutter/material.dart';
//
// // ─── How to use ───────────────────────────────────────────────────────────────
// // Call this anywhere in your app:
// //
// //   showDeleteAccountDialog(context);
// //
// // ─────────────────────────────────────────────────────────────────────────────
//
// void showDeleteAccountDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => const DeleteAccountDialog(),
//   );
// }
//
// class DeleteAccountDialog extends StatefulWidget {
//   const DeleteAccountDialog({super.key});
//
//   @override
//   State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
// }
//
// class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
//   final TextEditingController _controller = TextEditingController();
//   bool _isConfirmed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() {
//       setState(() {
//         _isConfirmed = _controller.text == 'DELETE';
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 480),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Title row ──────────────────────────────────────────────────
//               Row(
//                 children: [
//                   const Icon(Icons.warning_rounded,
//                       color: Color(0xFFE53935), size: 24),
//                   const SizedBox(width: 8),
//                   const Expanded(
//                     child: Text(
//                       'Delete Account',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFFE53935),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, size: 20),
//                     onPressed: () => Navigator.of(context).pop(),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // ── Warning box ────────────────────────────────────────────────
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFF0F0),
//                   border: Border.all(color: const Color(0xFFFFCDD2)),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RichText(
//                       text: const TextSpan(
//                         style: TextStyle(
//                             fontSize: 13.5, color: Color(0xFF333333)),
//                         children: [
//                           TextSpan(text: 'Warning: '),
//                           TextSpan(
//                             text: 'This action is permanent and irreversible',
//                             style: TextStyle(fontWeight: FontWeight.w700),
//                           ),
//                           TextSpan(
//                               text: '. The following data will be deleted:'),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ..._warningItems.map(
//                           (item) => Padding(
//                         padding: const EdgeInsets.only(bottom: 4),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('• ',
//                                 style: TextStyle(
//                                     color: Color(0xFF555555), fontSize: 13.5)),
//                             Expanded(
//                               child: Text(
//                                 item,
//                                 style: const TextStyle(
//                                     color: Color(0xFF555555), fontSize: 13.5),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ── Confirmation label ─────────────────────────────────────────
//               RichText(
//                 text: const TextSpan(
//                   style:
//                   TextStyle(fontSize: 14, color: Color(0xFF333333)),
//                   children: [
//                     TextSpan(text: 'Type '),
//                     TextSpan(
//                       text: 'DELETE',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFFE53935),
//                       ),
//                     ),
//                     TextSpan(text: ' to confirm'),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               // ── Text field ─────────────────────────────────────────────────
//               TextField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   hintText: 'Type DELETE here',
//                   hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
//                   contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 14, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(6),
//                     borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(6),
//                     borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(6),
//                     borderSide: const BorderSide(color: Color(0xFFE53935)),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // ── Action buttons ─────────────────────────────────────────────
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   // Cancel
//                   OutlinedButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       side: const BorderSide(color: Color(0xFFCCCCCC)),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6)),
//                     ),
//                     child: const Text('Cancel',
//                         style: TextStyle(color: Color(0xFF333333))),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   // Delete button
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _isConfirmed
//                           ? () {
//                         Navigator.of(context).pop();
//                         // TODO: add your delete account logic here
//                       }
//                           : null,
//                       icon: const Icon(Icons.delete_outline, size: 28),
//                       label: Padding(
//                         padding: const EdgeInsets.only(left: 18.0),
//                         child: const Text('Yes, Delete My Account', ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFE53935),
//                         disabledBackgroundColor: const Color(0xFFEF9A9A),
//                         foregroundColor: Colors.white,
//                         disabledForegroundColor: Colors.white70,
//                         // padding: const EdgeInsets.symmetric(
//                         //     horizontal: 20, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(6)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// const List<String> _warningItems = [
//   'All your contribution records',
//   'All event RSVPs and attendance data',
//   'All notifications',
//   'Your profile photo and personal data',
//   'Your account and login credentials',
// ];

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../app/routes/app_pages.dart';
import '../../../core/services/storage_service.dart';
import 'delete_account_service.dart';

// ─── How to use ───────────────────────────────────────────────────────────────
// Call this anywhere in your app:
//
//   showDeleteAccountDialog(context, baseUrl: 'https://your-api.com', token: 'your_token');
//
// ─────────────────────────────────────────────────────────────────────────────

void showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Hello! This is a SnackBar'),
      duration: Duration(seconds: 2),
    ),
  );
}


void showDeleteAccountDialog(
    BuildContext context, {
      required String baseUrl,
      required String token,
    }) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => DeleteAccountDialog(baseUrl: baseUrl, token: token),
  );
}

class DeleteAccountDialog extends StatefulWidget {
  final String baseUrl;
  final String token;

  const DeleteAccountDialog({
    super.key,
    required this.baseUrl,
    required this.token,
  });

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isConfirmed = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isConfirmed = _controller.text == 'DELETE';
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<void> _onDeletePressed() async {
  //   setState(() => _isLoading = true);
  //
  //   final service = DeleteAccountService(
  //     baseUrl: widget.baseUrl,
  //     token: widget.token,
  //   );
  //
  //   final result = await service.deleteAccount();
  //
  //   if (!mounted) return;
  //   setState(() => _isLoading = false);
  //
  //   if (result.isSuccess) {
  //     Navigator.of(context).pop(); // close dialog
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(result.message),
  //         backgroundColor: Colors.green,
  //         behavior: SnackBarBehavior.floating,
  //       ),
  //     );
  //
  //     // Navigate to login and clear all routes
  //     // Replace '/login' with your actual login route
  //     Navigator.of(context).pushNamedAndRemoveUntil(
  //       '/login',
  //           (route) => false,
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(result.message),
  //         backgroundColor: Colors.red,
  //         behavior: SnackBarBehavior.floating,
  //       ),
  //     );
  //   }
  // }

  Future<void> _onDeletePressed() async {
    setState(() => _isLoading = true);

    final service = DeleteAccountService(
      //baseUrl: widget.baseUrl,
      token: widget.token,
    );

    final result = await service.deleteAccount();

    if (!mounted) return;
    setState(() => _isLoading = false);

    // ✅ Replace this block
    if (result.isSuccess) {


      Navigator.of(context).pop();

      await Get.find<StorageService>().clearSession(); // 👈 clears token & user data

      Get.offAllNamed(Routes.LOGIN); // 👈 navigates to login & clears stack

      showSnackBar(context);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      print(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title row ──────────────────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.warning_rounded,
                      color: Color(0xFFE53935), size: 24),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ),
                  if (!_isLoading)
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Warning box ────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  border: Border.all(color: const Color(0xFFFFCDD2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 13.5, color: Color(0xFF333333)),
                        children: [
                          TextSpan(text: 'Warning: '),
                          TextSpan(
                            text: 'This action is permanent and irreversible',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                              text: '. The following data will be deleted:'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._warningItems.map(
                          (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(
                                    color: Color(0xFF555555), fontSize: 13.5)),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                    color: Color(0xFF555555), fontSize: 13.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Confirmation label ─────────────────────────────────────────
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                  children: [
                    TextSpan(text: 'Type '),
                    TextSpan(
                      text: 'DELETE',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    TextSpan(text: ' to confirm'),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Text field ─────────────────────────────────────────────────
              TextField(
                controller: _controller,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Type DELETE here',
                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Action buttons ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel
                  OutlinedButton(
                    onPressed:
                    _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      side: const BorderSide(color: Color(0xFFCCCCCC)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Color(0xFF333333))),
                  ),

                  const SizedBox(width: 12),

                  // Delete button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                      (_isConfirmed && !_isLoading) ? _onDeletePressed : null,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(Icons.delete_outline, size: 28),
                      label: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          _isLoading ? 'Deleting...' : 'Yes, Delete My Account',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        disabledBackgroundColor: const Color(0xFFEF9A9A),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<String> _warningItems = [
  'All your contribution records',
  'All event RSVPs and attendance data',
  'All notifications',
  'Your profile photo and personal data',
  'Your account and login credentials',
];