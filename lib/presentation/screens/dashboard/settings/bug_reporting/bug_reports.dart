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
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitBug() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid ?? 'anonymous';
      final description = _descriptionController.text.trim();

      // Send email

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bug report submitted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bug Reporting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Bug Description',
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Please enter a description' : null,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitBug,
                child: const Text('Submit Bug'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}