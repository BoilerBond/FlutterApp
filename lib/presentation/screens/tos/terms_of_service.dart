import 'package:flutter/material.dart';

class TermsOfServicePage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  TermsOfServicePage({super.key, required this.arguments});

  @override
  TermsOfServicePageState createState() => TermsOfServicePageState();
}

class TermsOfServicePageState extends State<TermsOfServicePage> {
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Introduction
            _buildSectionTitle('Introduction'),
            const Text(
              'Welcome to Boiler Bond, a dating app designed to help you connect with potential partners. '
              'By using this app, you agree to be bound by these Terms of Service. '
              'Please note that Boiler Bond currently does not offer in-app purchases or display advertisements.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Definitions'),
            const Text(
              'In these Terms, "we", "us", and "our" refer to Boiler Bond, and "you" refers to any user or visitor of the app. '
              'Key terms used herein are defined for clarity.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Acknowledgment'),
            const Text(
              'By accessing or using Boiler Bond, you acknowledge that you have read, understood, and agree to these Terms of Service. '
              'If you do not agree with these terms, please do not use the app.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('User Accounts'),
            const Text(
              'To access certain features of the app, you may need to create an account. '
              'You are responsible for maintaining the confidentiality of your account credentials and for any activity that occurs under your account.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Content'),
            const Text(
              'Users may post, share, and interact with content on Boiler Bond. '
              'You are solely responsible for the content you submit and must ensure that it complies with our community guidelines. '
              'We reserve the right to remove any content deemed inappropriate or in violation of these terms.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Copyright Policy'),
            const Text(
              'All content provided on this app is protected by copyright laws. Unauthorized copying, reproduction, or distribution of any content is prohibited.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Intellectual Property'),
            const Text(
              'All trademarks, logos, and other intellectual property displayed in the app are the property of Boiler Bond or their respective owners. '
              'No rights are granted to you to use any of these without our prior written consent.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('User Feedback'),
            const Text(
              'Any feedback, comments, or suggestions you provide regarding the app are non-confidential and become the property of Boiler Bond. '
              'We may use such feedback to improve our services without any obligation to you.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Links to Other Websites'),
            const Text(
              'Our app may contain links to third-party websites or services that are not owned or controlled by Boiler Bond. '
              'We are not responsible for the content or practices of any third-party websites, and your use of such sites is at your own risk.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Termination'),
            const Text(
              'We reserve the right to suspend or terminate your account and access to Boiler Bond at our sole discretion, '
              'with or without notice, if you breach these Terms of Service or engage in any conduct that may harm the app or its users.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Limitation of Liability'),
            const Text(
              'In no event shall Boiler Bond be liable for any indirect, incidental, special, consequential, or punitive damages, '
              'or any loss of profits or revenues, whether incurred directly or indirectly, arising from your use of the app.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('"AS IS" and "AS AVAILABLE" Disclaimer'),
            const Text(
              'The app is provided on an "AS IS" and "AS AVAILABLE" basis. Boiler Bond makes no representations or warranties of any kind, '
              'express or implied, regarding the reliability, availability, or suitability of the app for your needs.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Governing Law'),
            const Text(
              'These Terms of Service shall be governed by and construed in accordance with the laws of the jurisdiction in which Boiler Bond operates, '
              'without regard to its conflict of law provisions.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Disputes Resolution'),
            const Text(
              'Any disputes arising out of or relating to these Terms shall be resolved through amicable negotiations. '
              'If a resolution cannot be reached, the dispute will be submitted to binding arbitration in accordance with the applicable rules.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Severability and Waiver'),
            const Text(
              'If any provision of these Terms is found to be invalid or unenforceable, the remaining provisions will remain in full force and effect. '
              'The failure to enforce any right or provision of these Terms shall not constitute a waiver of such right or provision.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Changes'),
            const Text(
              'Boiler Bond reserves the right to modify these Terms of Service at any time. Any changes will be posted on this page '
              'and will be effective immediately upon posting. Your continued use of the app after any changes constitutes your acceptance of the new terms.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Contact Information'),
            const Text(
              'If you have any questions about these Terms of Service, please contact us at: deng279@purdue.edu',
              style: TextStyle(fontSize: 16),
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
                    'I have read and agree to the Terms of Service.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isConfirmed
                  ? () {
                      if (widget.arguments["navigatePath"].isNotEmpty) {
                        Navigator.pushReplacementNamed(context, widget.arguments["navigatePath"]);
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  : null,
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
