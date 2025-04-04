import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:datingapp/services/gemini_service.dart';

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
    
    setState(() {
      isLoading = true;
    });
    
    try {
      // Get the selected question and answer
      final questionIndex = selectedQuestionIndex ?? -1;
      final answer = answerController.text.trim();
      
      if (questionIndex >= 0 && answer.isNotEmpty) {
        // Use Gemini service to convert the answer to a numerical scale
        final question = questions[questionIndex];
        final geminiService = GeminiService();
        final scaleValue = await geminiService.convertLongFormToScale(question, answer);
        
        // Create or update the longFormScales map
        Map<String, int> longFormScales = {};
        
        // Get existing scales if available
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null && userData.containsKey('longFormScales')) {
            final existingScales = userData['longFormScales'];
            if (existingScales is Map) {
              // Convert from Map<dynamic, dynamic> to Map<String, int>
              existingScales.forEach((key, value) {
                if (key is String && value is int) {
                  longFormScales[key] = value;
                }
              });
            }
          }
        }
        
        // Update the scale for the current question
        longFormScales[question] = scaleValue;
        
        // Save to Firestore
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'longFormQuestion': questionIndex,
          'longFormAnswer': answer,
          'longFormScales': longFormScales,
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Long form data saved and converted to scale successfully.')),
        );
      } else {
        // Just save the basic data without conversion
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'longFormQuestion': questionIndex,
          'longFormAnswer': answer,
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Long form data saved.')),
        );
      }
    } catch (e) {
      print('Error saving long form data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
                  const SizedBox(height: 8),
                  const Text(
                    'Note: Your answer will be automatically converted to a -5 to 5 scale for matching purposes',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
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
