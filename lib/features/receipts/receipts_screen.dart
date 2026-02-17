import 'package:flutter/material.dart';

class ReceiptsScreen extends StatelessWidget {
	const ReceiptsScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: const [
						Icon(Icons.receipt_long, size: 64, color: Colors.blueGrey),
						SizedBox(height: 12),
						Text('Receipts', style: TextStyle(fontSize: 20)),
						SizedBox(height: 8),
						Text('Your receipts will appear here.'),
					],
				),
			),
		);
	}
}

