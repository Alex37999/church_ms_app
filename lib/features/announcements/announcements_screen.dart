import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.campaign, size: 64, color: Colors.orange),
            SizedBox(height: 12),
            Text('Announcements', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Latest announcements will appear here.'),
          ],
        ),
      ),
    );
  }
}
