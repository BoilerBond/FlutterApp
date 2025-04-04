import 'package:flutter/material.dart';

class LegalInformation extends StatefulWidget {
  const LegalInformation({super.key});

  @override
  State<LegalInformation> createState() => _LegalInformationState();
}

class _LegalInformationState extends State<LegalInformation> {
  final double _demoSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Legal Information")),
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
            _buildSectionTitle('Eligibility'),
            const Text(
              'You must be at least 18 years of age to create an account and use BoilerBond. '
              'By using the app, you represent and warrant that you meet this requirement. '
              'We reserve the right to terminate accounts of users found to be underage.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('User Conduct and Interactions'),
            const Text(
              'Boiler Bond is committed to maintaining a respectful and inclusive community. '
              'By using the app, you agree to interact with other users in a manner that is courteous, appropriate, and in accordance with these Terms. '
              'You must not engage in any behavior that is harassing, discriminatory, abusive, threatening, or otherwise harmful.\n\n'
              'Prohibited behaviors include, but are not limited to:\n'
              '- Sending unsolicited, inappropriate, or offensive messages or images\n'
              '- Impersonating another person or misrepresenting your identity\n'
              '- Stalking, intimidation, or repeated unwanted contact\n'
              '- Promoting or encouraging hate speech, racism, sexism, or any form of discrimination\n\n'
              'Boiler Bond reserves the right to investigate any account found to be in violation of these behavioral expectations, and implement measures in accordance to the infraction. '
              'We also reserve the right to report serious violations to appropriate authorities. Users are encouraged to report any misconduct via the in-app reporting tools.',
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
            _buildSectionTitle('Data Collection and Use'),
            const Text(
              'Boiler Bond collects personal and behavioral data to operate and improve the app experience, and enhance matchmaking recommendations. '
              'This includes but is not limited to profile information, onboarding information, preferences, and interactions within the app. '
              'We do not sell your personal data.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Matchmaking and Recommendations'),
            const Text(
              'Our app uses algorithmic logic to suggest matches based on profile information, preferences, and user ratings. '
              'Matches are not guaranteed and may vary week to week. '
              'We promote but do not guarantee compatibility or outcomes based on suggested matches.',
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
            _buildSectionTitle('Safety Disclaimer'),
            const Text(
              'While BoilerBond strives to foster a secure environment, we cannot guarantee the behavior or intentions of users. '
              'Always exercise caution when interacting with others, especially when meeting in person. '
              'We do not conduct criminal background checks.',
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
