import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_header.dart';
import './controllers/receipts_controller.dart';
import 'receipts_details_screen.dart';

class ReceiptsScreen extends GetView<ReceiptsController> {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            const AppHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'My Receipts',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Download your contribution receipts',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  if (ctrl.isLoading.value)
                    const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (ctrl.errorMessage.value.isNotEmpty)
                    Center(
                      child: Text(
                        ctrl.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )
                  else if (ctrl.receipts.isEmpty)
                    const Center(child: Text('No receipts available'))
                  else
                    ...ctrl.receipts.map((receipt) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 0.5,
                          shadowColor: Colors.black.withOpacity(0.04),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Get.to(
                              () => ContributionReceiptScreen(receipt: receipt),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEFF6FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.receipt_long,
                                      size: 20,
                                      color: Color(0xFF3B82F6),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                receipt.month,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${receipt.contributionsCount} contribution(s)',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'KES ${receipt.totalAmount.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDFF7E7),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          receipt.status,
                                          style: const TextStyle(
                                            color: Color(0xFF057A34),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () => ctrl.downloadReceipt(
                                      receipt.downloadUrl ?? '',
                                    ),
                                    icon: const Icon(
                                      Icons.download_outlined,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 22,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
