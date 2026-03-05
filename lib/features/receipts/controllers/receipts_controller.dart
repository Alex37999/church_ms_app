import 'dart:io';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ReceiptsController extends GetxController {
  final RxList<ReceiptModel> receipts = <ReceiptModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReceipts();
  }

  Future<void> fetchReceipts() async {
    isLoading.value = true;
    try {
      final resp = await ApiClient().get('/api/member/receipts');
      final body = resp.data;
      if (body == null || body['success'] != true) {
        errorMessage.value = 'Failed to load receipts';
        receipts.clear();
        return;
      }

      final data = body['data'] ?? {};
      final List items = (data['receipts'] ?? []) as List;
      final mapped = items.map<ReceiptModel>((raw) {
        final contributeDate = (raw['contribute_date'] ?? '').toString();
        String monthLabel = contributeDate;
        try {
          final dt = DateTime.parse(contributeDate);
          const monthNames = [
            '',
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ];
          monthLabel = '${monthNames[dt.month]} ${dt.year}';
        } catch (_) {}

        final amount = (raw['amount'] ?? 0).toDouble();
        final type = (raw['type'] ?? '').toString();

        return ReceiptModel(
          id: (raw['id'] ?? '').toString(),
          month: monthLabel,
          totalAmount: amount,
          date: contributeDate,
          status: (raw['status'] ?? '').toString(),
          contributionsCount: 1,
          memberName: (raw['branch'] ?? '').toString(),
          memberNo: (raw['receipt_number'] ?? '').toString(),
          contributions: [
            ReceiptContribution(
              label: type
                  .replaceAll('_', ' ')
                  .split(' ')
                  .map(
                    (s) => s.isEmpty
                        ? s
                        : '${s[0].toUpperCase()}${s.substring(1)}',
                  )
                  .join(' '),
              date: contributeDate,
              amount: amount,
            ),
          ],
          downloadUrl: (raw['download_url'] ?? '').toString(),
        );
      }).toList();

      receipts.assignAll(mapped);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch receipts: $e';
      receipts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadReceipt(String url) async {
    if (url.isEmpty) {
      Get.snackbar('Download', 'No download URL available');
      return;
    }

    Get.snackbar('Download', 'Downloading receipt...');

    try {
      // Use ApiClient's Dio instance to preserve auth headers
      final resp = await ApiClient().getBytes(url);
      final bytes = resp.data;
      if (bytes == null) throw Exception('Empty response');

      // Choose filename from URL or timestamp
      String filename = 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf';
      try {
        final uri = Uri.parse(url);
        final seg = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
        if (seg.isNotEmpty) filename = seg;
      } catch (_) {}

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(List<int>.from(bytes), flush: true);

      Get.snackbar('Download', 'Saved to ${file.path}');

      // Try to open the file (may fail on some platforms)
      try {
        await OpenFile.open(file.path);
      } catch (_) {}
    } catch (e) {
      // Do not open external browser — keep download behavior inside app.
      await Clipboard.setData(ClipboardData(text: url));
      Get.snackbar(
        'Download failed',
        'Could not download file; URL copied to clipboard',
      );
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
  final String? downloadUrl;

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
    this.downloadUrl,
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
