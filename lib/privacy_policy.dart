import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  PrivacyPolicyPageState createState() => PrivacyPolicyPageState();
}

class PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'This Privacy Policy explains how the Boiler Bond app (hereinafter referred to as "Application") collects, uses, '
              'and protects your personal information. By downloading or using the Application, you agree to the practices described herein. '
              'Please read this policy carefully before using the Application.\n',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Information Collection'),
            const Text(
              'We collect information that you voluntarily provide when using the Application. This includes your email address, '
              'first name, last name, age, sexual orientation, and gender. This information is used to personalize your experience '
              'and to provide more tailored content and services.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Usage Data'),
            const Text(
              'The Application may also collect data on how it is accessed and used. This can include your device’s IP address, browser type, '
              'pages visited, and the dates and times of your visits, which help us to analyze trends and improve our services.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Third-Party Services'),
            const Text(
              'Our Application may use third-party services that have their own privacy policies. Please review the following links for more details:\n'
              'Google Play Services: https://policies.google.com/privacy\n'
              'Google Analytics for Firebase: https://firebase.google.com/policies/analytics',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Data Security'),
            const Text(
              'We implement reasonable security measures to protect your personal information. However, no method of transmission over the Internet '
              'or method of electronic storage is 100% secure.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('User Rights'),
            const Text(
              'You have the right to access, correct, or delete your personal information. If you wish to exercise these rights, please contact us at: deng279@purdue.edu',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Changes to This Privacy Policy'),
            const Text(
              'We may update this Privacy Policy periodically. Any changes will be posted on this page, so please review it regularly.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Effective Date: 2025-02-28',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isConfirmed,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isConfirmed = newValue ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'I have read and understood the Privacy Policy.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isConfirmed
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 183, 228, 245),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
