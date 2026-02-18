import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_header.dart';
import './controllers/receipts_controller.dart';

class ReceiptsScreen extends GetView<ReceiptsController> {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppHeader(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipts',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (controller.isLoading.value)
                  const Center(child: CircularProgressIndicator())
                else if (controller.receipts.isEmpty)
                  const Center(child: Text('No receipts available'))
                else
                  ...controller.receipts.map((receipt) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Icon(
                              Icons.receipt_long,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          title: Text(receipt.month),
                          subtitle: Text(receipt.date),
                          trailing: Text(
                            'KES ${receipt.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
