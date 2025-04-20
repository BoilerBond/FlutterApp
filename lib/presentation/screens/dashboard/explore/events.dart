import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventRoomScreen extends StatefulWidget {
  const EventRoomScreen({super.key});

  @override
  State<EventRoomScreen> createState() => _EventRoomScreenState();
}

class _EventRoomScreenState extends State<EventRoomScreen> {
  String? matchId;
  String? question;
  String? userAnswer;
  String? matchAnswer;
  String? guess;
  String? matchName = "Your match";
  bool isAnswering = false;
  bool isGuessing = false;
  bool isCompleted = false;
  bool hasSubmittedAnswer = false;
  bool hasSubmittedGuess = false;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    matchId = userDoc.data()?['match'];
    if (matchId == null || matchId!.isEmpty) return;

    final eventSnapshot = await FirebaseFirestore.instance
        .collection("events")
        .doc("active_events")
        .collection(matchId!)
        .doc("current")
        .get();

    if (!eventSnapshot.exists) return;

    final data = eventSnapshot.data()!;
    question = data['question'];
    isAnswering = data['answeringPhase'] ?? false;
    isGuessing = data['guessingPhase'] ?? false;
    isCompleted = data['completed'] ?? false;
    userAnswer = data[uid];
    guess = data["${uid}_guess"];

    final matchUID = await _getMatchUid(uid!);
    matchAnswer = data[matchUID];

    setState(() {
      hasSubmittedAnswer = userAnswer != null;
      hasSubmittedGuess = guess != null;
    });

    if (isAnswering && !hasSubmittedAnswer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showAnswerPopup();
      });
    } else if (isGuessing && !hasSubmittedGuess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showGuessPopup();
      });
    }
  }

  Future<String> _getMatchUid(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final match = snapshot.data()?['match'];
    return match ?? "";
  }

  Future<void> _showAnswerPopup() async {
    String answer = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your Answer"),
        content: TextField(
          onChanged: (value) => answer = value,
          decoration: InputDecoration(hintText: question),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              await FirebaseFirestore.instance
                  .collection("events")
                  .doc("active_events")
                  .collection(matchId!)
                  .doc("current")
                  .update({uid: answer});
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
        title: Text("Guess $matchName's Answer"),
        content: TextField(
          onChanged: (value) => userGuess = value,
          decoration: InputDecoration(hintText: question),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              await FirebaseFirestore.instance
                  .collection("events")
                  .doc("active_events")
                  .collection(matchId!)
                  .doc("current")
                  .update({"${uid}_guess": userGuess});
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
    if (question == null) return Center(child: Text("No current event."));

    if (isCompleted) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Event Complete!",
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 12),
            Text("Your answer: $userAnswer"),
            Text("Your guess: $guess"),
            Text("Actual answer from match: $matchAnswer"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEventData,
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
          Text("Event Ongoing!",
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),
          Text("Question: $question"),
          SizedBox(height: 20),
          if (isAnswering)
            hasSubmittedAnswer
                ? Text("You've answered! Waiting for your match...")
                : ElevatedButton(
                    onPressed: _showAnswerPopup,
                    child: Text("Answer Now"),
                  )
          else if (isGuessing)
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
