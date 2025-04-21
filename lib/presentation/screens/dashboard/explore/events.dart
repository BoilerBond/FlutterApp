import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/entity/app_user.dart';

class EventRoomScreen extends StatefulWidget {
  const EventRoomScreen({super.key});

  @override
  State<EventRoomScreen> createState() => _EventRoomScreenState();
}

class _EventRoomScreenState extends State<EventRoomScreen> {
  AppUser? curUser;
  AppUser? matchUser;
  bool hasSubmittedAnswer = false;
  bool hasSubmittedGuess = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final db = FirebaseFirestore.instance;
    final userSnap = await db.collection("users").doc(uid).get();
    final user = AppUser.fromSnapshot(userSnap);

    AppUser? match;
    if (user.match.isNotEmpty) {
      final matchSnap = await db.collection("users").doc(user.match).get();
      match = AppUser.fromSnapshot(matchSnap);
    }

    setState(() {
      curUser = user;
      matchUser = match;
      hasSubmittedAnswer = curUser!.currentEventAnswer != null;
      hasSubmittedGuess = curUser!.currentEventGuess != null;
    });

    if (curUser!.currentEventPhase == "answering" && !hasSubmittedAnswer) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showAnswerPopup());
    } else if (curUser!.currentEventPhase == "guessing" && !hasSubmittedGuess) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showGuessPopup());
    }
  }

  Future<void> _initiateEvent() async {
    if (curUser == null || matchUser == null) return;

    final questions = [
      "What’s your go-to comfort food?",
      "If you could travel anywhere right now, where would it be?",
      "What’s a movie you could watch over and over?",
      "What's your dream vacation?",
      "What's something people often misunderstand about you?",
    ];
    final selectedQuestion = (questions..shuffle()).first;


try {
  await FirebaseFirestore.instance.collection('users').doc(curUser!.uid).update({
    'currentEventQuestion': selectedQuestion,
    'currentEventPhase': 'answering',
    'currentEventAnswer': null,
    'currentEventGuess': null
  });
  print("Updated current user: ${curUser!.uid}");
} catch (e) {
  print("Failed to update current user: $e");
}

try {
  await FirebaseFirestore.instance.collection('users').doc(matchUser!.uid).update({
    'currentEventQuestion': selectedQuestion,
    'currentEventPhase': 'answering',
    'currentEventAnswer': null,
    'currentEventGuess': null
  });
  print("Updated match user: ${matchUser!.uid}");
} catch (e) {
  print("Failed to update match user: $e");
}
    _loadUserData();
  }

  Future<void> _showAnswerPopup() async {
    String answer = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your Answer"),
        content: TextField(
          onChanged: (value) => answer = value,
          decoration: InputDecoration(hintText: curUser!.currentEventQuestion),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection("users").doc(curUser!.uid).update({
                'currentEventAnswer': answer
              });
              Navigator.of(context).pop();
              setState(() => hasSubmittedAnswer = true);
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }

  Future<void> _showGuessPopup() async {
    String userGuess = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Guess your match's answer"),
        content: TextField(
          onChanged: (value) => userGuess = value,
          decoration: InputDecoration(hintText: curUser!.currentEventQuestion),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection("users").doc(curUser!.uid).update({
                'currentEventGuess': userGuess
              });
              Navigator.of(context).pop();
              setState(() => hasSubmittedGuess = true);
            },
            child: Text("Submit Guess"),
          )
        ],
      ),
    );
  }

  Widget _buildEventContent() {
    if (curUser == null || matchUser == null || curUser!.currentEventQuestion == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No current event."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initiateEvent,
              child: Text("Start a New Event"),
            ),
          ],
        ),
      );
    }

    if (curUser!.currentEventPhase == "completed") {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Event Complete!", style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 12),
            Text("Your answer: ${curUser!.currentEventAnswer}"),
            Text("Your guess: ${curUser!.currentEventGuess}"),
            Text("Match answer: ${matchUser!.currentEventAnswer}"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserData,
              child: Text("Refresh"),
            )
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Event Ongoing!", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),
          Text("Question: ${curUser!.currentEventQuestion}"),
          SizedBox(height: 20),
          if (curUser!.currentEventPhase == 'answering')
            hasSubmittedAnswer
                ? Text("You've answered! Waiting for your match...")
                : ElevatedButton(
                    onPressed: _showAnswerPopup,
                    child: Text("Answer Now"),
                  )
          else if (curUser!.currentEventPhase == 'guessing')
            hasSubmittedGuess
                ? Text("You've guessed! Waiting for results...")
                : ElevatedButton(
                    onPressed: _showGuessPopup,
                    child: Text("Guess Now"),
                  )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digital Event Room"),
      ),
      body: _buildEventContent(),
    );
  }
}
