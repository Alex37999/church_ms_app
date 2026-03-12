import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_theme.dart';
import '../widgets/app_header.dart';
import './controllers/receipts_controller.dart';

class ReceiptsScreen extends GetView<ReceiptsController> {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            AppHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Summary header with gradient background
                  Obx(() {
                    final total = ctrl.receipts.fold<double>(
                      0.0,
                      (s, r) => s + (r.totalAmount ?? 0),
                    );
                    final count = ctrl.receipts.length;
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0B3B8C), Color(0xFF1E66D1)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(14, 30, 60, 0.12),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL RECEIPTS',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'KSh ${_formatAmount(total)}',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$count receipts available',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(15, 23, 42, 0.06),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(color: AppTheme.cardBorder),
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
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5FF),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.receipt_long_outlined,
                                      size: 22,
                                      color: Color(0xFF1E3A8A),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          receipt.month,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1F2937),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${receipt.contributionsCount} contribution(s)',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: const Color(0xFF64748B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE7F8EC),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: 6,
                                                height: 6,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF22C55E),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                receipt.status,
                                                style: GoogleFonts.poppins(
                                                  color: const Color(
                                                    0xFF16A34A,
                                                  ),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'KSh ${_formatAmount(receipt.totalAmount)}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Material(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () => ctrl.downloadReceipt(
                                            receipt.downloadUrl ?? '',
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.download_outlined,
                                              size: 20,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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

String _formatAmount(double? value) {
  final v = (value ?? 0).toStringAsFixed(0);
  return v.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}
