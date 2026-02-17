import 'package:flutter/material.dart';

class ReceiptAddPage extends StatelessWidget {
  const ReceiptAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Receipt')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Receipt creation form goes here.'),
      ),
    );
  }
}
