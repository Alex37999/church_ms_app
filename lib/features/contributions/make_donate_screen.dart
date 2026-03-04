import 'package:flutter/material.dart';
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
    final pm = _paymentMethod.toLowerCase().contains('bank')
        ? 'bank'
        : _paymentMethod.toLowerCase();

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

    Future<void> doPost() async {
      try {
        final form = dio.FormData.fromMap(map);
        final resp = await ApiClient().post('/api/member/donate', data: form);
        final body = resp.data;
        if (body != null && body['success'] == true) {
          Get.snackbar('Success', 'Donation submitted');
          // Refresh contributions list if controller available
          try {
            final contribCtrl = Get.find<ContributionsController>();
            await contribCtrl.fetchContributions();
            await contribCtrl.fetchReceipts();
          } catch (_) {}
          Navigator.of(context).maybePop();
        } else {
          final msg = body != null && body['message'] != null
              ? body['message'].toString()
              : 'Failed to submit donation';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final modalWidth = width > 700 ? 520.0 : width - 40.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                          // DropdownMenuItem(
                          //   value: 'M-PESA',
                          //   child: Text('M-PESA'),
                          // ),
                          DropdownMenuItem(
                            value: 'Bank Transfer',
                            child: Text('Bank Transfer'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _paymentMethod = v ?? 'Cash'),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          hintText: 'e.g. 1000',
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                          decoration: const InputDecoration(
                            hintText: 'Transaction code (required for bank)',
                            border: OutlineInputBorder(),
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
                      Container(
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
                                  label: const Text('Submit Donation'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE11D48),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
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
