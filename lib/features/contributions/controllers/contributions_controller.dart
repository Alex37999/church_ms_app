import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import 'package:flutter/services.dart';

class ContributionsController extends GetxController {
  final RxList<ContributionModel> contributions = <ContributionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalContributions = 0.0.obs;
  final RxDouble totalThisYear = 0.0.obs;
  final RxDouble totalThisMonth = 0.0.obs;
  final RxDouble averageAmount = 0.0.obs;
  final RxDouble changeThisMonthPercent =
      0.0.obs; // percent change vs previous month

  @override
  void onInit() {
    super.onInit();
    fetchContributions();
    fetchReceipts();
  }

  // Receipts
  final RxList<ReceiptItem> receipts = <ReceiptItem>[].obs;
  // Bank accounts provided by the API
  final RxList<BankAccount> bankAccounts = <BankAccount>[].obs;

  Future<void> fetchReceipts() async {
    try {
      final resp = await ApiClient().get('/api/member/receipts');
      final body = resp.data;
      if (body == null || body['success'] != true) {
        return;
      }

      final data = body['data'] ?? {};
      final List items = (data['receipts'] ?? []) as List;
      final mapped = items.map<ReceiptItem>((raw) {
        return ReceiptItem(
          id: (raw['id'] ?? '').toString(),
          receiptNumber: (raw['receipt_number'] ?? '').toString(),
          amount: (raw['amount'] ?? 0).toDouble(),
          date: (raw['contribute_date'] ?? '').toString(),
          downloadUrl: (raw['download_url'] ?? '').toString(),
          status: (raw['status'] ?? '').toString(),
          type: (raw['type'] ?? '').toString(),
          paymentMethod: (raw['payment_method'] ?? '').toString(),
        );
      }).toList();

      receipts.assignAll(mapped);
    } catch (_) {
      // ignore
    }
  }

  Future<void> copyReceiptUrlToClipboard(String url) async {
    if (url.isEmpty) {
      Get.snackbar('Download', 'No download URL available');
      return;
    }
    await Clipboard.setData(ClipboardData(text: url));
    Get.snackbar('Download', 'Receipt URL copied to clipboard');
  }

  Future<void> fetchContributions() async {
    isLoading.value = true;
    try {
      final resp = await ApiClient().get('/api/member/contributions');
      final body = resp.data;

      if (body == null || body['success'] != true) {
        errorMessage.value = 'Failed to load contributions';
        contributions.clear();
        return;
      }

      final data = body['data'] ?? {};

      // Map stats
      final stats = data['stats'] ?? {};
      totalThisYear.value = (stats['total_this_year'] ?? 0).toDouble();
      totalThisMonth.value = (stats['total_this_month'] ?? 0).toDouble();
      averageAmount.value = (stats['average'] ?? 0).toDouble();
      changeThisMonthPercent.value = (stats['month_change_pct'] ?? 0)
          .toDouble();

      // Map contributions list into local model
      final List items = (data['contributions'] ?? []) as List;
      final mapped = items.map<ContributionModel>((raw) {
        String type = (raw['type'] ?? '').toString();
        // Convert snake_case to Title Case
        type = type
            .replaceAll('_', ' ')
            .split(' ')
            .map((s) {
              if (s.isEmpty) return s;
              return s[0].toUpperCase() + s.substring(1);
            })
            .join(' ');

        return ContributionModel(
          id: (raw['id'] ?? '').toString(),
          type: type,
          amount: (raw['amount'] ?? 0).toDouble(),
          date: (raw['contribute_date'] ?? '').toString(),
          status: (raw['status'] ?? '').toString(),
          method: (raw['payment_method'] ?? '').toString(),
          time: raw['created_at']?.toString(),
          transactionCode: raw['transaction_code']?.toString(),
        );
      }).toList();

      contributions.assignAll(mapped);

      // Map bank accounts
      final List bankItems = (data['bank_accounts'] ?? []) as List;
      final mappedBanks = bankItems.map<BankAccount>((raw) {
        return BankAccount(
          id: raw['id'] is int
              ? raw['id'] as int
              : int.tryParse(raw['id']?.toString() ?? '0') ?? 0,
          bankName: (raw['bank_name'] ?? '').toString(),
          accountName: (raw['account_name'] ?? '').toString(),
          accountNumber: (raw['account_number'] ?? '').toString(),
          branchName: (raw['branch_name'] ?? '').toString(),
          routingNumber: (raw['routing_number'] ?? '').toString(),
          swiftCode: (raw['swift_code'] ?? '').toString(),
          instructions: (raw['instructions'] ?? '').toString(),
        );
      }).toList();
      bankAccounts.assignAll(mappedBanks);

      calculateTotal();
      // metrics are driven by API stats, but keep calculateMetrics to ensure consistency
      calculateMetrics();

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch contributions: $e';
      contributions.clear();
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

  void calculateMetrics() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    double yearSum = 0.0;
    double monthSum = 0.0;
    double prevMonthSum = 0.0;

    for (final c in contributions) {
      try {
        final dt = DateTime.parse(c.date).toLocal();
        if (dt.year == currentYear) yearSum += c.amount;
        if (dt.year == currentYear && dt.month == currentMonth)
          monthSum += c.amount;
        // prev month calculation
        final prev = DateTime(currentYear, currentMonth - 1);
        if (dt.year == prev.year && dt.month == prev.month)
          prevMonthSum += c.amount;
      } catch (_) {
        // ignore parse errors
      }
    }

    totalThisYear.value = yearSum;
    totalThisMonth.value = monthSum;

    averageAmount.value = contributions.isEmpty
        ? 0.0
        : (contributions.fold(0.0, (s, it) => s + it.amount) /
              contributions.length);

    if (prevMonthSum == 0) {
      changeThisMonthPercent.value = monthSum == 0 ? 0.0 : 100.0;
    } else {
      changeThisMonthPercent.value =
          ((monthSum - prevMonthSum) / prevMonthSum) * 100.0;
    }
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
  final String? time;
  final String? transactionCode;

  ContributionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    this.method = 'M-PESA',
    this.time,
    this.transactionCode,
  });
}

class ReceiptItem {
  final String id;
  final String receiptNumber;
  final double amount;
  final String date;
  final String downloadUrl;
  final String status;
  final String type;
  final String paymentMethod;

  ReceiptItem({
    required this.id,
    required this.receiptNumber,
    required this.amount,
    required this.date,
    required this.downloadUrl,
    required this.status,
    required this.type,
    required this.paymentMethod,
  });
}

class BankAccount {
  final int id;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String branchName;
  final String routingNumber;
  final String swiftCode;
  final String instructions;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.branchName,
    required this.routingNumber,
    required this.swiftCode,
    required this.instructions,
  });
}
