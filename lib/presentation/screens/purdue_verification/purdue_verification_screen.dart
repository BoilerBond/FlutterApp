import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:datingapp/utils/validators/email_validator.dart';

class PurdueVerificationScreen extends StatefulWidget {
  const PurdueVerificationScreen({super.key});

  @override
  _PurdueVerificationScreenState createState() => _PurdueVerificationScreenState();
}

class _PurdueVerificationScreenState extends State<PurdueVerificationScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _emailValidator = EmailValidator(validatePurdueEmail: true);

  bool _isLoading = true;
  bool _isSubmitting = false;
  String _errorMessage = '';
  String _successMessage = '';
  bool _codeSent = false;
  bool _isVerified = false;
  String? _verifiedEmail;

  @override
  void initState() {
    super.initState();
    _checkVerificationStatus();
  }

  Future<void> _checkVerificationStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'You must be logged in to verify your email.';
          _isLoading = false;
        });
        return;
      }

      // Call Firebase Function to check verification status
      final token = await user.getIdToken();
      final callable = FirebaseFunctions.instance.httpsCallable('user-verification-checkPurdueEmailVerification');
      final result = await callable.call({"uid" : user.uid});
      
      final data = result.data as Map<String, dynamic>;
            
      setState(() {
        _isVerified = data['verified'] ?? false;
        _verifiedEmail = data['purdueEmail'];
        _isLoading = false;
      });
      
      if (_isVerified && _verifiedEmail != null) {
        // Already verified, automatically navigate to the next screen after a delay
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, "/onboarding");
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to check verification status. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (!_emailFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          _errorMessage = 'You must be logged in to verify your email.';
          _isSubmitting = false;
        });
        return;
      }

      // Call Firebase Function to send verification code
      final callable = FirebaseFunctions.instance.httpsCallable('user-verification-sendPurdueVerificationCode');
      final result = await callable.call({
        'email': _emailController.text.trim(),
      });

      setState(() {
        _successMessage = 'Verification code sent to your email. Please check your inbox.';
        _isSubmitting = false;
        _codeSent = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e is FirebaseFunctionsException
            ? e.message ?? 'An error occurred. Please try again.'
            : 'An unexpected error occurred. Please try again.';
        _isSubmitting = false;
      });
    }
  }

  Future<void> _verifyCode() async {
    if (!_codeFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      // Call Firebase Function to verify the code
      final callable = FirebaseFunctions.instance.httpsCallable('user-verification-verifyPurdueEmail');
      final result = await callable.call({
        'email': _emailController.text.trim(),
        'code': _codeController.text.trim(),
      });

      setState(() {
        _successMessage = 'Email verified successfully!';
        _isSubmitting = false;
        _isVerified = true;
        _verifiedEmail = _emailController.text.trim();
      });

      // Wait a moment to show the success message, then navigate
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, "/onboarding");
      });
    } catch (e) {
      setState(() {
        _errorMessage = e is FirebaseFunctionsException
            ? e.message ?? 'An error occurred. Please try again.'
            : 'An unexpected error occurred. Please try again.';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purdue Email Verification'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isVerified
              ? _buildVerifiedUI()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: _codeSent ? _buildVerificationCodeUI() : _buildEmailEntryUI(),
                  ),
                ),
    );
  }

  Widget _buildVerifiedUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Purdue Email Verified',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your Purdue email $_verifiedEmail has been verified.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Redirecting to the next step...',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailEntryUI() {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Verify Your Purdue Email',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter your Purdue email address to receive a verification code.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Purdue Email',
              hintText: 'example@purdue.edu',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _emailValidator.validate,
            autocorrect: false,
          ),
          const SizedBox(height: 24),
          _buildMessageContainers(),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _sendVerificationCode,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Send Verification Code', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCodeUI() {
    return Form(
      key: _codeFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Enter Verification Code',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Enter the 6-digit verification code sent to ${_emailController.text}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _codeSent = false;
                _errorMessage = '';
                _successMessage = '';
              });
            },
            child: const Text('Change Email'),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Verification Code',
              hintText: '6-digit code',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the verification code';
              }
              if (value.length != 6 || int.tryParse(value) == null) {
                return 'Please enter a valid 6-digit code';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildMessageContainers(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _sendVerificationCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.grey[300],
                  ),
                  child: const Text('Resend Code', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContainers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_errorMessage.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
        if (_successMessage.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _successMessage,
              style: TextStyle(color: Colors.green.shade900),
            ),
          ),
      ],
    );
  }
}
