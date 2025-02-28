import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Boiler Bond'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Boiler Bond Works',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Boiler Bond is a dating app created with the intention of creating long-lasting relationships. '
              'Our process is uniquely designed to understand your preferences and connect you with a compatible partner.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Profile Setup & Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'When you sign up, you fill in information about yourself as well as what you are looking for in a partner. '
              'You can also set filters to narrow down potential matches based on your preferences.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '2. Swiping Window (Friday 6pm - Sunday 6pm)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Every week from Friday at 6pm to Sunday at 6pm, you will have the opportunity to swipe on other user profiles. '
              'Swipe right to like and left to dislike. This activity builds our algorithm to understand your dating preferences.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '3. Matching Process (Sunday 6pm)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'At Sunday 6pm, our algorithm processes the swipes from the week and selects your number one match. '
              'Once matched, you can chat exclusively with that one person until the next swiping window opens.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '4. Extended Conversations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you wish to take the conversation further and continue chatting beyond the designated period, '
              'you will need to exchange contact information within the app.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '5. Match Priority',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you do not receive a match during the swiping window, you will be given a higher priority for matching '
              'in the following week, increasing your chances for a connection.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Mission',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'At Boiler Bond, we are dedicated to creating a platform that goes beyond casual dating. '
              'Our app is built with the goal of forming genuine, long-lasting relationships based on shared values and mutual interests.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Enjoy using Boiler Bond and best of luck finding your perfect match!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
