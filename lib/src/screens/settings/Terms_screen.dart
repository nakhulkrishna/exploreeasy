import 'package:flutter/material.dart';

class TermsAndServices extends StatelessWidget {
  const TermsAndServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Services'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Last updated: 28-09-2024',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Exploreesy! By using our application, you agree to the following terms and conditions:\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '1. Acceptance of Terms\n'
              '- By accessing and using this application, you accept and agree to be bound by these Terms and Services.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '2. User Responsibilities\n'
              '- You agree to use the application only for lawful purposes and in a manner that does not infringe on the rights of others.\n'
              '- You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '3. Intellectual Property\n'
              '- All content, trademarks, and other intellectual property rights related to the application are owned by Exploreesy or its licensors.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '4. Limitation of Liability\n'
              '- To the fullest extent permitted by law, Exploreesy shall not be liable for any direct, indirect, incidental, or consequential damages resulting from your use of the application.\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '5. Changes to Terms\n'
              '- We may update these Terms and Services from time to time. Changes will be notified to you by updating this page.\n',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'If you have any questions about these Terms and Services, please contact us at: exploreeasy2024@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
