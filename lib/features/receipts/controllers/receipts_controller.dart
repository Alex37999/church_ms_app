import 'package:get/get.dart';

class ReceiptsController extends GetxController {
  final RxList<ReceiptModel> receipts = <ReceiptModel>[].obs;
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
      receipts.assignAll([
        ReceiptModel(
          id: 'REC-004',
          month: 'February 2026',
          totalAmount: 15000,
          date: '2026-02-10',
          status: 'Available',
          contributionsCount: 2,
          memberName: 'David Otieno',
          memberNo: 'GCC-1024',
          contributions: [
            ReceiptContribution(
              label: 'Tithe',
              date: '2026-02-15',
              amount: 10000,
            ),
            ReceiptContribution(
              label: 'Offering',
              date: '2026-02-08',
              amount: 5000,
            ),
          ],
        ),
        ReceiptModel(
          id: 'REC-001',
          month: 'January 2026',
          totalAmount: 15000,
          date: '2026-02-01',
          status: 'Available',
          contributionsCount: 2,
          memberName: 'Grace Njoroge',
          memberNo: 'GCC-0987',
          contributions: [
            ReceiptContribution(
              label: 'Tithe',
              date: '2026-01-15',
              amount: 10000,
            ),
            ReceiptContribution(
              label: 'Offering',
              date: '2026-01-08',
              amount: 5000,
            ),
          ],
        ),
        ReceiptModel(
          id: 'REC-002',
          month: 'December 2025',
          totalAmount: 20000,
          date: '2026-01-01',
          status: 'Available',
          contributionsCount: 3,
          memberName: 'Samuel Karanja',
          memberNo: 'GCC-0765',
          contributions: [
            ReceiptContribution(
              label: 'Tithe',
              date: '2025-12-15',
              amount: 10000,
            ),
            ReceiptContribution(
              label: 'Offering',
              date: '2025-12-08',
              amount: 5000,
            ),
            ReceiptContribution(
              label: 'Special',
              date: '2025-12-20',
              amount: 5000,
            ),
          ],
        ),
        ReceiptModel(
          id: 'REC-003',
          month: 'November 2025',
          totalAmount: 10000,
          date: '2025-12-01',
          status: 'Available',
          contributionsCount: 1,
          memberName: 'Alice Wambui',
          memberNo: 'GCC-0456',
          contributions: [
            ReceiptContribution(
              label: 'Tithe',
              date: '2025-11-15',
              amount: 10000,
            ),
          ],
        ),
      ]);
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
  final int contributionsCount;
  final String? memberName;
  final String? memberNo;
  final List<ReceiptContribution>? contributions;

  ReceiptModel({
    required this.id,
    required this.month,
    required this.totalAmount,
    required this.date,
    required this.status,
    this.contributionsCount = 0,
    this.memberName,
    this.memberNo,
    this.contributions,
  });
}

class ReceiptContribution {
  final String label;
  final String date;
  final double amount;

  ReceiptContribution({
    required this.label,
    required this.date,
    required this.amount,
  });
}
