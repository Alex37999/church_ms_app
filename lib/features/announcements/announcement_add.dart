import 'package:flutter/material.dart';

class AnnouncementAddPage extends StatelessWidget {
  const AnnouncementAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Announcement')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Announcement creation form goes here.'),
      ),
    );
  }
}
