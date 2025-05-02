import 'package:datingapp/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppDescriptionScreen extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  const AppDescriptionScreen({super.key, required this.arguments});

  @override
  _AppDescriptionScreenState createState() => _AppDescriptionScreenState();
}

class _AppDescriptionScreenState extends State<AppDescriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Boiler Bond', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.outlineVariant),
                      foregroundColor: MaterialTheme.warning,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                    onPressed: () {
                      User? currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        FirebaseAuth.instance.signOut();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      if (widget.arguments["navigateToTos"]) {
                        Navigator.pushNamed(context, "/terms_of_service", arguments: {"navigatePath": widget.arguments["navigatePath"], "navigateToTos": false});
                      } else {
                        if (widget.arguments["navigatePath"].isNotEmpty) {
                          Navigator.pushReplacementNamed(context, widget.arguments["navigatePath"]);
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
