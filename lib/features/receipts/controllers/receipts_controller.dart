import 'package:get/get.dart';

class ReceiptsController extends GetxController {
  final RxList receipts = <ReceiptModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReceipts();
  }

  void fetchReceipts() {
    isLoading.value = true;
    try {
      // Initialize with sample data
      receipts.value = [
        ReceiptModel(
          id: 'REC-001',
          month: 'January 2026',
          totalAmount: 50000,
          date: '2026-02-01',
          status: 'Issued',
        ),
        ReceiptModel(
          id: 'REC-002',
          month: 'December 2025',
          totalAmount: 45000,
          date: '2026-01-01',
          status: 'Issued',
        ),
        ReceiptModel(
          id: 'REC-003',
          month: 'November 2025',
          totalAmount: 48000,
          date: '2025-12-01',
          status: 'Issued',
        ),
      ];
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch receipts: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class ReceiptModel {
  final String id;
  final String month;
  final double totalAmount;
  final String date;
  final String status;

  ReceiptModel({
    required this.id,
    required this.month,
    required this.totalAmount,
    required this.date,
    required this.status,
  });
}
