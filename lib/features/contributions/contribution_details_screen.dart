import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_header.dart';
import './controllers/contributions_controller.dart';

class ContributionDetailsScreen extends StatelessWidget {
  final ContributionModel contribution;

  const ContributionDetailsScreen({Key? key, required this.contribution})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppHeader(showBackButton: true, onBack: () => Get.back()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Total Amount',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'KES ${contribution.amount.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFF7E7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          contribution.status,
                          style: const TextStyle(
                            color: Color(0xFF057A34),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Contribution Details',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        _detailRow('Type', contribution.type),
                        const Divider(),
                        _detailRow('Payment Method', contribution.method),
                        const Divider(),
                        _detailRow('Date', contribution.date),
                        const Divider(),
                        _detailRow('Time', contribution.time ?? '--'),
                        const Divider(),
                        _detailRow(
                          'Transaction Code',
                          contribution.transactionCode ?? '--',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () => Get.to(
                    () => ContributionDetailsScreen(contribution: contribution),
                  ),
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'View Receipt',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Download Receipt not implemented'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Download Receipt',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
