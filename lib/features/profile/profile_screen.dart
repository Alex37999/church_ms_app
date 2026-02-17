import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
	const ProfileScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: const [
						CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
						SizedBox(height: 12),
						Text('Profile', style: TextStyle(fontSize: 20)),
						SizedBox(height: 8),
						Text('User details and settings.'),
					],
				),
			),
		);
	}
}
