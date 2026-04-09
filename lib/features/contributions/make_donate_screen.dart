import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import 'package:dio/dio.dart' as dio;
import './controllers/contributions_controller.dart';

class MakeDonateScreen extends StatefulWidget {
  const MakeDonateScreen({super.key});

  @override
  State<MakeDonateScreen> createState() => _MakeDonateScreenState();
}

class _MakeDonateScreenState extends State<MakeDonateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  String _paymentMethod = 'Cash';
  String? _contributionType;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _transactionCodeCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _dateCtrl.text = _formattedDate(_selectedDate);
  }

  String _formattedDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  Widget _bankRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = _formattedDate(picked);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final amountText = _amountCtrl.text.replaceAll(',', '').trim();
    final amount = double.tryParse(amountText) ?? 0.0;
    final contributeDate =
        "${_selectedDate.year.toString().padLeft(4, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

    final type = (_contributionType ?? '').toLowerCase().replaceAll(' ', '_');
    // final pm = _paymentMethod.toLowerCase().contains('bank')
    //     ? 'bank'
    //     : _paymentMethod.toLowerCase();

    final pm = _paymentMethod.toLowerCase().contains('bank')
        ? 'bank'
        : _paymentMethod.toLowerCase() == 'mpesa'
        ? 'mpesa'
        : 'cash';




    final map = <String, dynamic>{
      'amount': amount.toString(),
      'contribute_date': contributeDate,
      'type': type,
      'payment_method': pm,
      'note': _noteCtrl.text.trim(),
    };
    if (pm == 'bank') {
      map['transaction_code'] = _transactionCodeCtrl.text.trim();
    }
    if (pm == 'mpesa') {
      map['phone'] = _phoneCtrl.text.trim();
    }

    // Future<void> doPost() async {
    //   try {
    //     final form = dio.FormData.fromMap(map);
    //     final resp = await ApiClient().post('/api/member/donate', data: form);
    //     final body = resp.data;
    //     if (body != null && body['success'] == true) {
    //       Get.snackbar('Success', 'Donation submitted');
    //       // Refresh contributions list if controller available
    //       try {
    //         final contribCtrl = Get.find<ContributionsController>();
    //         await contribCtrl.fetchContributions();
    //         await contribCtrl.fetchReceipts();
    //       } catch (_) {}
    //       Navigator.of(context).maybePop();
    //     } else {
    //       final msg = body != null && body['message'] != null
    //           ? body['message'].toString()
    //           : 'Failed to submit donation';
    //       Get.snackbar('Error', msg);
    //     }
    //   } catch (e) {
    //     Get.snackbar('Error', e.toString());
    //   } finally {
    //     if (mounted) setState(() => _isSubmitting = false);
    //   }
    // }

    // Add before the doPost() call

    ///

    // Future<void> doPost() async {
    //   try {
    //     final form = dio.FormData.fromMap(map);
    //     final resp = await ApiClient().post('/api/member/donate', data: form);
    //     final body = resp.data;
    //
    //     if (body != null && body['success'] == true) {
    //       final isMpesa = pm == 'mpesa';
    //
    //       Get.snackbar(
    //         'Success',
    //         isMpesa
    //             ? 'M-Pesa initiated! Use reference: ${body['contribution']?['receiot_number'] ?? ''}'
    //             : 'Donation submitted successfully',
    //         duration: const Duration(seconds: 5),
    //       );
    //
    //       try {
    //         final contribCtrl = Get.find<ContributionsController>();
    //         await contribCtrl.fetchContributions();
    //         await contribCtrl.fetchReceipts();
    //       } catch (_) {}
    //
    //       Navigator.of(context).maybePop();
    //     } else {
    //       final msg = body?['message']?.toString() ?? 'Failed to submit';
    //       Get.snackbar('Error', msg);
    //     }
    //   } catch (e) {
    //     Get.snackbar('Error', e.toString());
    //   } finally {
    //     if (mounted) setState(() => _isSubmitting = false);
    //   }
    // }

    ///

    // Future<void> doPost() async {
    //   try {
    //     final form = dio.FormData.fromMap(map);
    //     final resp = await ApiClient().post('/api/member/donate', data: form);
    //     final body = resp.data;
    //
    //     if (body != null && body['success'] == true) {
    //       // Refresh contributions
    //       try {
    //         final contribCtrl = Get.find<ContributionsController>();
    //         await contribCtrl.fetchContributions();
    //         await contribCtrl.fetchReceipts();
    //       } catch (_) {}
    //
    //       // Close the donation form first
    //       Navigator.of(context).maybePop();
    //
    //       // Show success dialog for M-Pesa
    //       if (pm == 'mpesa') {
    //         final contribution = body['contribution'] as Map<String, dynamic>? ?? {};
    //         await showDialog(
    //           context: context,
    //           barrierDismissible: false,
    //           builder: (_) => MPesaSuccessDialog(contribution: contribution),
    //         );
    //       } else {
    //         Get.snackbar('Success', body['message']?.toString() ?? 'Donation submitted');
    //       }
    //     } else {
    //       final msg = body?['message']?.toString() ?? 'Failed to submit donation';
    //       Get.snackbar('Error', msg);
    //     }
    //   } catch (e) {
    //     Get.snackbar('Error', e.toString());
    //   } finally {
    //     if (mounted) setState(() => _isSubmitting = false);
    //   }
    // }

    ///

    Future<void> doPost() async {
      try {
        final form = dio.FormData.fromMap(map);
        final resp = await ApiClient().post('/api/member/donate', data: form);
        final body = resp.data;

        if (body != null && body['success'] == true) {
          // Refresh contributions
          try {
            final contribCtrl = Get.find<ContributionsController>();
            await contribCtrl.fetchContributions();
            await contribCtrl.fetchReceipts();
          } catch (_) {}

          if (pm == 'mpesa') {
            final mpesaData = Map<String, dynamic>.from(body as Map? ?? {});

            Navigator.of(context).maybePop();

            Get.dialog(
              MPesaSuccessDialog(data: mpesaData),
              barrierDismissible: false,
            );
          } else {
            Get.snackbar(
              'Success',
              body['message']?.toString() ?? 'Donation submitted successfully',
            );
            Navigator.of(context).maybePop();
          }
        } else {
          final msg = body?['message']?.toString() ?? 'Failed to submit donation';
          Get.snackbar('Error', msg);
        }
      } catch (e) {
        Get.snackbar('Error', e.toString());
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }


    doPost();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _dateCtrl.dispose();
    _noteCtrl.dispose();
    _transactionCodeCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final modalWidth = width > 700 ? 520.0 : width - 40.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: modalWidth),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Make a Donation',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Payment Method
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            'Payment Method *',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: _paymentMethod,
                        items: const [
                          DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                          DropdownMenuItem(
                            value: 'mpesa',
                            child: Text('M-PESA'),
                          ),
                          DropdownMenuItem(
                            value: 'Bank Transfer',
                            child: Text('Bank Transfer'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _paymentMethod = v ?? 'Cash'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Show bank instructions immediately after selecting Bank Transfer
                      if (_paymentMethod.toLowerCase().contains('bank')) ...[
                        Builder(
                          builder: (ctx) {
                            final contribCtrl =
                                Get.find<ContributionsController>();
                            return Obx(() {
                              if (contribCtrl.bankAccounts.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F7FF),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFBEE6F9),
                                    ),
                                  ),
                                  child: const Text(
                                    'No bank account information available.',
                                  ),
                                );
                              }

                              final acc = contribCtrl.bankAccounts.first;
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F7FF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFBEE6F9),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          color: Color(0xFF0B6FBF),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Bank Transfer Instructions',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF0B6FBF),
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _bankRow('Bank Name:', acc.bankName),
                                    const SizedBox(height: 6),
                                    _bankRow('Account Name:', acc.accountName),
                                    const SizedBox(height: 6),
                                    _bankRow(
                                      'Account Number:',
                                      acc.accountNumber,
                                    ),
                                    const SizedBox(height: 6),
                                    _bankRow('Bank Branch:', acc.branchName),
                                    const SizedBox(height: 6),
                                    _bankRow(
                                      'Routing Number:',
                                      acc.routingNumber,
                                    ),
                                    const SizedBox(height: 6),
                                    _bankRow('SWIFT / BIC:', acc.swiftCode),
                                    const SizedBox(height: 6),
                                    _bankRow('Instructions:', acc.instructions),
                                  ],
                                ),
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Show m-pesa instructions immediately after selecting M-PESA

                      if (_paymentMethod.toLowerCase().contains('mpesa'))
                        Padding(
                          padding: const EdgeInsets.only(bottom : 12),
                          child: MPesaInstructionsCard(),
                        ),


                      //const SizedBox(height: 12),


                      // Phone Number (only for Mpesa)
                      if (_paymentMethod.toLowerCase().contains('mpesa')) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              'M-Pesa Phone Number *',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:  Colors.grey,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Row(
                            children: [
                              // Phone icon
                              const Icon(
                                Icons.phone,
                                color: Color(0xFF444444),
                                size: 20,
                              ),

                              const SizedBox(width: 10),

                              // Divider line between icon and text field
                              Container(
                                width: 1,
                                height: 24,
                                color: const Color(0xFFCCCCCC),
                              ),

                              const SizedBox(width: 10),

                              // Text input
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 12,
                                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: const TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Colors.red),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Colors.red),
                                    ),
                                    hintText: '254XXXXXXXXX',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFAAAAAA),
                                      fontSize: 15,
                                    ),
                                  ),
                                  validator: (v) {
                                    if (_paymentMethod.toLowerCase() != 'mpesa') return null;
                                    if (v == null || v.trim().isEmpty) return 'Enter M-Pesa phone number';
                                    if (v.trim().length != 12) return 'Must be exactly 12 digits';
                                    if (!v.trim().startsWith('254')) return 'Must start with 254';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),


                        Text('Format: 254 followed by 9 digits (e.g. 254712345678)', style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w200, color: Colors.grey.shade600
                        ),)

                      ],


                      const SizedBox(height: 20),

                      // Amount
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            'Amount (KSh) *',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g. 1000',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Enter amount';
                          final n = double.tryParse(v.replaceAll(',', ''));
                          if (n == null || n <= 0) return 'Enter valid amount';
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Contribution Type
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            'Contribution Type *',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: _contributionType,
                        hint: const Text('-- Select type --'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Tithe',
                            child: Text('Tithe'),
                          ),
                          DropdownMenuItem(
                            value: 'Offering',
                            child: Text('Offering'),
                          ),
                          // DropdownMenuItem(
                          //   value: 'Donation',
                          //   child: Text('Donation'),
                          // ),
                          DropdownMenuItem(
                            value: 'Building Fund',
                            child: Text('Building Fund'),
                          ),
                        ],
                        onChanged: (v) => setState(() => _contributionType = v),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Choose contribution type'
                            : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Contribution Date
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            'Contribution Date *',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _dateCtrl,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Choose a date' : null,
                      ),

                      const SizedBox(height: 12),

                      // Note
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            'Note (optional)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _noteCtrl,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Transaction code (only for bank)
                      if (_paymentMethod.toLowerCase().contains('bank')) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              'Transaction Code *',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _transactionCodeCtrl,
                          decoration: InputDecoration(
                            hintText: 'Transaction code (required for bank)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (_paymentMethod.toLowerCase().contains('bank')) {
                              if (v == null || v.trim().isEmpty)
                                return 'Enter transaction code';
                            }
                            return null;
                          },
                        ),
                      ],


                      const SizedBox(height: 12),



                      // Warning box



                      _paymentMethod.toLowerCase().contains('mpesa')
                          ? Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6EEF8), // light blue background
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF90CAE4), // soft blue border
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Info icon
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.info,
                                color: Color(0xFF2A8BBE),
                                size: 18,
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Message text with bold inline segment
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Color(0xFF2A8BBE),
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                      'Once your M-Pesa payment is confirmed by Safaricom, your donation will be ',
                                    ),
                                    TextSpan(
                                      text: 'automatically approved',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4E5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFEAD6A7)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFFB7791F),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Your donation will remain Pending until confirmed by the administrator.',
                                style: TextStyle(color: Colors.brown[700]),
                              ),
                            ),
                          ],
                        ),
                      ),



                      const SizedBox(height: 14),

                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          _isSubmitting
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    width: 120,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: _submit,
                                  icon: const Icon(Icons.send, size: 18),
                                  label: _paymentMethod.toLowerCase().contains('mpesa')? Text('Pay via M-Pesa') : Text('Submit Donation'),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFFE11D48),
                                    ),
                                    foregroundColor: MaterialStateProperty.all(
                                      Colors.white,
                                    ),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    side:
                                        MaterialStateProperty.resolveWith<
                                          BorderSide?
                                        >((states) {
                                          if (states.contains(
                                            MaterialState.pressed,
                                          )) {
                                            return BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.85),
                                            );
                                          }
                                          return BorderSide(
                                            color: Colors.grey.shade400,
                                          );
                                        }),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class MPesaInstructionsCard extends StatelessWidget {
  const MPesaInstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD6EFE0), // light mint green background
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: const Color(0xFF2E7D52), // dark green left accent border
            width: 4,
          ),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with icon and title
          Row(
            children: [
              Icon(
                Icons.smartphone,
                color: const Color(0xFF2E7D52),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'M-Pesa Payment Instructions',
                style: TextStyle(
                  color: const Color(0xFF2E7D52),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Body text with bold inline segments
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xFF2E7D52),
                fontSize: 14,
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text:
                  'Enter your Safaricom phone number below, then click ',
                ),
                const TextSpan(
                  text: 'Submit Donation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text:
                  '. We will generate a unique reference code for you to use when paying via M-Pesa. Paybill / Shortcode: ',
                ),
                const TextSpan(
                  text: '600986',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MPesaSuccessDialog extends StatefulWidget {
  final Map<String, dynamic> data;

  const MPesaSuccessDialog({super.key, required this.data});

  @override
  State<MPesaSuccessDialog> createState() => _MPesaSuccessDialogState();
}

class _MPesaSuccessDialogState extends State<MPesaSuccessDialog> {


  bool _showTimeout = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 20), () {
      if (mounted) {
        setState(() => _showTimeout = true);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    // Parse directly from API response fields
    final reference = widget.data['reference']?.toString() ?? '-';
    final amount = widget.data['amount']?.toString() ?? '-';
    final shortcode = widget.data['shortcode']?.toString() ?? '600986';
    final message = widget.data['message']?.toString() ?? '';

    // Steps from instructions object
    final instructions = widget.data['instructions'] as Map? ?? {};
    final steps = (instructions['steps'] as List?)
        ?.map((e) => e.toString())
        .toList() ??
        [];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD6EFE0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF2E7D52),
                    size: 36,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'M-Pesa Payment Initiated!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF777777)),
                ),

                const SizedBox(height: 20),

                // Reference + Amount card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    children: [
                      _infoRow('Reference Code:', reference, highlight: true),
                      const SizedBox(height: 8),
                      _infoRow('Amount:', 'KSh $amount'),
                      const SizedBox(height: 8),
                      _infoRow('Paybill / Shortcode:', shortcode),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Steps
                if (steps.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6EFE0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFB2DFCC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.smartphone,
                                color: Color(0xFF2E7D52), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'How to Pay',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D52),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...steps.asMap().entries.map(
                              (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(
                                      right: 8, top: 1),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2E7D52),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${e.key + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    e.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF2E7D52),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 14),

                // Waiting for confirmation banner

                if (!_showTimeout) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6F4F8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFADE4EC)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0097A7)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: const Text(
                            'Waiting for your payment confirmation...',
                            style: TextStyle(
                              color: Color(0xFF006070),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (_showTimeout) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: const Text(
                      "We are still waiting for Safaricom's confirmation. Please check your contribution history in a few minutes.",
                      style: TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],


                // Auto-update info banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF1D4ED8), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Color(0xFF1E3A5F),
                              fontSize: 13,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text:
                                'This page will automatically update once Safaricom confirms your payment. You can also close this dialog and check your ',
                              ),
                              TextSpan(
                                text: 'Contribution History',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' below.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    //onPressed: () => Get.back(),
                    onPressed: () {
                      int count = 0;
                      Get.until((route) => count++ >= 2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D52),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Close', style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF555555),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight
                  ? const Color(0xFF2E7D52)
                  : const Color(0xFF222222),
            ),
          ),
        ),
      ],
    );
  }
}




