import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/constants/constants.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/view_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../data/entity/app_user.dart';
import 'long_form_questions_screen.dart';
import 'edit_traits.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _imageURL = "";
  String? userName = "";
  String? bio = "";
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  final List<String> questions = [
    'What are your long-term goals?',
    'What are your short-term goals?',
    'What kind of communication style do you have?',
    'How do you handle conflict in a relationship?',
    'What is your love language like?'
  ];

  Future<void> getProfile() async {
    if (currentUser != null) {
      final userSnapshot =
          await db.collection("users").doc(currentUser?.uid).get();
      final user = AppUser.fromSnapshot(userSnapshot);
      setState(() {
        userName = "${user.firstName} ${user.lastName}";
        bio = user.bio;
        _imageURL = user.profilePictureURL;
      });
    } else {
      print("error getting current user using auth");
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {
        'title': 'Edit Profile',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/profile/edit_profile");
        }
      },
      {
        'title': 'View Profile',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/profile/view_profile");
        }
      },
      {
        'title': 'Profile Privacy',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/profile/profile_privacy");
        }
      },
    ];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Welcome back, ${userName ?? ""}!",
                style: const TextStyle(height: 2, fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
                backgroundImage: NetworkImage(
                  (_imageURL != null && _imageURL!.isNotEmpty)
                      ? _imageURL!
                      : Constants.defaultProfilePictureURL,
                ),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(bio ?? ""),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: buttons.map((btn) {
                  return TextButton(
                    onPressed: () => btn['onPressed'](context),
                    child: Text(btn['title']),
                  );
                }).toList(),
              ),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: db.collection('users').doc(currentUser!.uid).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    int index = data['longFormQuestion'] ?? -1;
                    final question = (index >= 0 && index < questions.length)
                        ? questions[index]
                        : 'No question set';
                    final answer =
                        data['longFormAnswer'] ?? 'No answer provided';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Long Form Q&A:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Question: $question'),
                        const SizedBox(height: 8),
                        Text('Answer: $answer'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LongFormQuestionScreen(),
                              ),
                            );
                          },
                          child: const Text('Edit Long Form Questions'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Prompt of the day goes in here"),
                        SizedBox(height: 8),
                        TextField(
                          maxLines: 5,
                          minLines: 1,
                          style: TextStyle(height: 1),
                          decoration: InputDecoration(
                            hintText: "My answer...",
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
