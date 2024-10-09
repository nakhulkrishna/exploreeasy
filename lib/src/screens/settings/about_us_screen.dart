import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Last updated: 28-09-2024',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Exploreesy! We are dedicated to providing you with the best travel planning experience. Our app allows you to manage your trips, track expenses, and share memories, all in one place.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '1. Our Mission\n'
              '- To simplify travel planning and make your journeys more enjoyable.\n'
              '- To empower travelers with tools and features that enhance their travel experiences.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '2. Our Values\n'
              '- User-centric design: We prioritize our users\' needs in every feature we develop.\n'
              '- Privacy and security: We are committed to protecting your personal information.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '3. Contact Us\n'
              '- If you have any questions, feedback, or concerns, please reach out to us:\n'
              '- Email: exploreEasy2024@gmail.com\n'
              '- Follow us on social media: https://www.linkedin.com/in/nakhul-krishna-61a472309?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app\n',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for choosing Exploreesy! We look forward to helping you plan your next adventure.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
