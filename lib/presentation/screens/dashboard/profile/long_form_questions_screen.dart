import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/data/entity/app_user.dart';

class LongFormQuestionScreen extends StatefulWidget {
  const LongFormQuestionScreen({super.key});

  @override
  _LongFormQuestionScreenState createState() => _LongFormQuestionScreenState();
}

class _LongFormQuestionScreenState extends State<LongFormQuestionScreen> {
  final List<String> questions = [
    'What are your long-term goals?',
    'What are your short-term goals?',
    'What kind of communication style do you have?',
    'How do you handle conflict in a relationship?',
    'What is your love language like?'
  ];

  int? selectedQuestionIndex;
  final TextEditingController answerController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLongFormData();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  Future<void> _loadLongFormData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    try {
      AppUser user = await AppUser.getById(currentUser.uid);
      setState(() {
        selectedQuestionIndex = user.longFormQuestion;
        answerController.text = user.longFormAnswer;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading long form data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _saveLongFormData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'longFormQuestion': selectedQuestionIndex ?? -1,
        'longFormAnswer': answerController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Long form data saved successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Long Form Question'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select a Question:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<int>(
                    isExpanded: true,
                    value: (selectedQuestionIndex != null &&
                            selectedQuestionIndex! >= 0 &&
                            selectedQuestionIndex! < questions.length)
                        ? selectedQuestionIndex
                        : null,
                    hint: const Text('Select a question'),
                    items: List.generate(questions.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(questions[index]),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedQuestionIndex = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Answer:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: answerController,
                    decoration: const InputDecoration(
                      hintText: 'Type your answer here...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveLongFormData,
                      child: const Text('Save Answer'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
