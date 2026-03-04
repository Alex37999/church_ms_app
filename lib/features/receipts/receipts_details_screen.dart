import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_header.dart';
import './controllers/receipts_controller.dart';

class ContributionReceiptScreen extends StatelessWidget {
  final ReceiptModel? receipt;

  const ContributionReceiptScreen({Key? key, this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReceiptModel r = receipt ?? (Get.arguments as ReceiptModel);

    // Safely extract fields
    final memberName = r.memberName ?? 'Member Name';
    final memberNo = r.memberNo ?? 'N/A';
    final contributions = r.contributions ?? <ReceiptContribution>[];
    final total = r.totalAmount;
    final month = r.month;

    Widget _buildContributionRow(dynamic item) {
      final label = item is ReceiptContribution
          ? item.label
          : (item?['label'] ?? 'Contribution');
      final date = item is ReceiptContribution
          ? item.date
          : (item?['date'] ?? '');
      final amount = item is ReceiptContribution
          ? item.amount
          : (item?['amount'] ?? 0);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                if (date != null && date.isNotEmpty)
                  Text(
                    date,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
              ],
            ),
            Text(
              'KES ${amount.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppHeader(showBackButton: true, onBack: () => Get.back()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Grace Community Church',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Westside Branch',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 12),

                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Contribution Receipt',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              if (month.isNotEmpty)
                                Text(
                                  month,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Member Name:',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    memberName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Member No:',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    memberNo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'Contributions:',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),

                        if (contributions.isNotEmpty)
                          ...contributions
                              .map<Widget>((c) => _buildContributionRow(c))
                              .toList()
                        else
                          Column(
                            children: [
                              _buildContributionRow({
                                'label': 'Tithe',
                                'date': '2026-02-15',
                                'amount': 10000,
                              }),
                              const Divider(),
                              _buildContributionRow({
                                'label': 'Offering',
                                'date': '2026-02-08',
                                'amount': 5000,
                              }),
                            ],
                          ),

                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount:',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'KES ${total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E40AF),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: () {
                            final ctrl = Get.find<ReceiptsController>();
                            if ((r.downloadUrl ?? '').isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No download URL available'),
                                ),
                              );
                              return;
                            }
                            ctrl.downloadReceipt(r.downloadUrl ?? '');
                          },
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Color(0xFF2563EB),
                          ),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Download PDF',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Color(0xFF2563EB),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
        ],
      ),
    );
  }
}
