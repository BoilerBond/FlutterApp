import 'package:flutter/material.dart';

class EventRoomScreen extends StatefulWidget {
  const EventRoomScreen({super.key});

  @override
  State<EventRoomScreen> createState() => _EventRoomScreenState();
}

class _EventRoomScreenState extends State<EventRoomScreen> {
  bool hasJoinedEvent = false;
  String? selectedQuestion;

  final List<String> funQuestions = [
    "If you could travel anywhere in the world, where would you go and why?",
    "What's a hobby you've always wanted to try but never did?",
    "What movie could you watch over and over again?",
    "Describe your perfect weekend.",
    "If you were an ice cream flavor, what would you be?"
  ];

  void _startEvent() {
    setState(() {
      hasJoinedEvent = true;
      funQuestions.shuffle();
      selectedQuestion = funQuestions.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              if (!hasJoinedEvent) ...[
                const Text(
                  "Welcome to your Digital Event Room!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C519C),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Here, you and your match can answer fun bonding questions during the week!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _startEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C519C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Start Event"),
                )
              ] else if (selectedQuestion != null) ...[
                const Text(
                  "Today’s Question:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C519C),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF5E77DF), width: 1),
                  ),
                  child: Text(
                    selectedQuestion!,
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your answer...",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Answer submitted!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C519C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Submit Answer"),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
