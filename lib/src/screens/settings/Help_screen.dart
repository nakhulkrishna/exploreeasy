import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help & Support',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Last updated: 28-09-2024',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Frequently Asked Questions (FAQs)\n'
              '- Q: How do I add a trip?\n'
              '- A: To add a trip, navigate to the trips section and click the "Add Trip" button.\n\n'
              '- Q: How can I delete a memory image?\n'
              '- A: Long press the image in your memories section and select "Delete".\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '2. Contact Us\n'
              '- If you have any further questions or need assistance, please contact our support team:\n'
              '- Email: exploreeasy2024@gmial.com\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '3. App Features\n'
              '- This app allows you to plan your trips, manage expenses, and capture memories.\n'
              '- Explore different features in the app for a better travel experience.\n',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for using Exploreesy! We hope you have a great experience.\n',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
