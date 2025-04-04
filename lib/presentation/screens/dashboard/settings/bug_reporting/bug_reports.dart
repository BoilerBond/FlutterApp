// ...existing code...
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BugReportingScreen extends StatefulWidget {
  const BugReportingScreen({Key? key}) : super(key: key);

  @override
  _BugReportingScreenState createState() => _BugReportingScreenState();
}


class _BugReportingScreenState extends State<BugReportingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  Future<void> _submitBug() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        // First, explicitly check auth status
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          print("DEBUG: User is not authenticated");
          // Consider showing auth error or redirecting to login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You must be logged in to submit a report'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        
        print("DEBUG: User authenticated with ID: ${user.uid}");
        
        final reportData = {
          'type': 'BUG',
          'target': _stepsController.text.trim(),
          'description': _descriptionController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        };
        
        print("DEBUG: Attempting to write to Firestore with data: $reportData");
        
        // Add to Firestore with explicit error handling
        final docRef = await FirebaseFirestore.instance.collection('reports').add(reportData);
        
        print("DEBUG: Successfully wrote document with ID: ${docRef.id}");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bug report submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        _stepsController.clear();
      } catch (e) {
        print("DEBUG: Firestore write error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting report: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bug Reporting'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Bug Title',
                    hintText: 'Enter a brief title describing the issue',
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Bug Description',
                    hintText: 'Describe the issue in detail',
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please enter a description' : null,
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stepsController,
                  decoration: const InputDecoration(
                    labelText: 'Steps to Reproduce',
                    hintText: 'List the steps needed to reproduce this bug',
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please enter steps to reproduce' : null,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitBug,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Submit Bug Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}