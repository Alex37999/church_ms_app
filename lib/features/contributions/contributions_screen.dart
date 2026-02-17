import 'package:flutter/material.dart';

class ContributionsScreen extends StatelessWidget {
	const ContributionsScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: const [
						Icon(Icons.attach_money, size: 64, color: Colors.green),
						SizedBox(height: 12),
						Text('Contributions', style: TextStyle(fontSize: 20)),
						SizedBox(height: 8),
						Text('List of contributions will appear here.'),
					],
				),
			),
		);
	}
}
