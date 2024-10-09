import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Last updated: 28-09-2024',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your information when you use our application.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '1. Information Collection\n'
              '- We never collect personal information such as your credit, email address, and and personal information.\n'
              '- data never collected by automatically, including your IP address and interaction with the app.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '2. Use of Information\n'
              '- We never use the information collected to provide, maintain, and improve our services.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '3. Data Security\n'
              '- We implement appropriate technical and organizational measures to protect your personal information.\n'
              '- However, no method of transmission over the internet or method of electronic storage is 100% secure.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '4. Changes to This Policy\n'
              '- We may update our Privacy Policy from time to time. Changes will be notified to you by updating this page.\n',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'If you have any questions about this Privacy Policy, please contact us at: [Insert Contact Information]',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
