import 'package:get/get.dart';

class ContributionsController extends GetxController {
  final RxList<ContributionModel> contributions = <ContributionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalContributions = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContributions();
  }

  void fetchContributions() {
    isLoading.value = true;
    try {
      // Initialize with sample data
      contributions.assignAll([
        ContributionModel(
          id: '1',
          type: 'Tithe',
          amount: 10000,
          date: '2026-02-15',
          status: 'Completed',
          method: 'M-PESA',
        ),
        ContributionModel(
          id: '2',
          type: 'Offering',
          amount: 5000,
          date: '2026-02-10',
          status: 'Completed',
          method: 'Bank Transfer',
        ),
        ContributionModel(
          id: '3',
          type: 'Building Fund',
          amount: 20000,
          date: '2026-02-05',
          status: 'Completed',
          method: 'M-PESA',
        ),
      ]);
      calculateTotal();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch contributions: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void calculateTotal() {
    totalContributions.value = contributions.fold(
      0,
      (sum, item) => sum + item.amount,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class ContributionModel {
  final String id;
  final String type;
  final double amount;
  final String date;
  final String status;
  final String method;

  ContributionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    this.method = 'M-PESA',
  });
}
