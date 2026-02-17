import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/app_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(title: Text('ChurchMS (${ctrl.env})')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Environment: ${ctrl.env}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final res = await ctrl.fetchStatus();
                Get.snackbar('API', res?.toString() ?? 'no response');
              },
              child: const Text('Check API'),
            ),
          ],
        ),
      ),
    );
  }
}
