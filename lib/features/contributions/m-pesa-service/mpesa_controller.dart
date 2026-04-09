import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mpesa_service_class.dart';

class MpesaController extends GetxController {
  final _mpesaService = MpesaService();

  // ─── Form ──────────────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final shortCodeController = TextEditingController();
  final amountController = TextEditingController();
  final msisdnController = TextEditingController();
  final billRefController = TextEditingController();

  // ─── State ─────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final commandId = 'CustomerPayBillOnline'.obs; // or CustomerBuyGoodsOnline

  final commandOptions = [
    'CustomerPayBillOnline',
    'CustomerBuyGoodsOnline',
  ];


  @override
  void onInit() {
    super.onInit();
    // Sandbox test defaults — remove before going live
    shortCodeController.text = '600000';
    amountController.text = '';
    msisdnController.text = '254708374149';
    billRefController.text = 'test123';
  }


  // ─── Simulate C2B Payment ──────────────────────────────────────────────────
  Future<void> simulatePayment() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final result = await _mpesaService.simulateC2BPayment(
      shortCode: shortCodeController.text.trim(),
      commandId: commandId.value,
      amount: amountController.text.trim(),
      msisdn: msisdnController.text.trim(),
      billRefNumber: billRefController.text.trim(),
    );

    isLoading.value = false;

    if (result.isSuccess) {
      Get.snackbar(
        'Payment Simulated ✅',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Simulation Failed ❌',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void onClose() {
    shortCodeController.dispose();
    amountController.dispose();
    msisdnController.dispose();
    billRefController.dispose();
    super.onClose();
  }
}