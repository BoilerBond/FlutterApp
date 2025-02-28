import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:datingapp/utils/validators/email_validator.dart';

class PurdueVerificationScreen extends StatefulWidget {
  const PurdueVerificationScreen({super.key});

  @override
  _PurdueVerificationScreenState createState() => _PurdueVerificationScreenState();
}

class _PurdueVerificationScreenState extends State<PurdueVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailValidator = EmailValidator(validatePurdueEmail: true);
  
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  Future<void> _verifyPurdueEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });
    
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        setState(() {
          _errorMessage = 'You must be logged in to verify your email.';
          _isLoading = false;
        });
        return;
      }
      
      // Send email verification link
      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: _emailController.text.trim(),
        actionCodeSettings: ActionCodeSettings(
          url: 'https://datingapp.page.link/verify',
          handleCodeInApp: true,
          iOSBundleId: 'com.example.datingapp',
          androidPackageName: 'com.example.datingapp',
          androidInstallApp: true,
          androidMinimumVersion: '12',
        ),
      );
      
      setState(() {
        _successMessage = 'Verification email sent! Please check your inbox.';
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred. Please try again.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purdue Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Please verify your Purdue email address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your Purdue email address to verify your account. We\'ll send you a verification link.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Purdue Email',
                  hintText: 'example@purdue.edu',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _emailValidator.validate,
              ),
              const SizedBox(height: 24),
              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.shade100,
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              if (_successMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.green.shade100,
                  child: Text(
                    _successMessage,
                    style: TextStyle(color: Colors.green.shade900),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyPurdueEmail,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Verify Email', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 