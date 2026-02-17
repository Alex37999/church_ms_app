import 'package:flutter/material.dart';

class ContributionAddPage extends StatelessWidget {
  const ContributionAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contribution')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text('Add contribution form goes here.'),
          ],
        ),
      ),
    );
  }
}
