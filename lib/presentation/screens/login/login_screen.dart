import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:datingapp/utils/validators/email_validator.dart';
import 'package:datingapp/utils/validators/password_validator.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // Not needed for standin solution

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _errorMessage = "";
  bool _isFirebaseAvailable = true;

  final emailValidator = EmailValidator(validatePurdueEmail: true);
  final passwordValidator = PasswordValidator();

  @override
  void initState() {
    super.initState();
    _checkFirebaseAvailability();
  }

  void _checkFirebaseAvailability() {
    try {
      FirebaseAuth.instance.authStateChanges();
      setState(() {
        _isFirebaseAvailable = true;
      });
    } catch (e) {
      setState(() {
        _isFirebaseAvailable = false;
      });
      print("Firebase auth error: $e");
    }
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _loginWithApple() async {
    if (!_isFirebaseAvailable) {
      setState(() {
        _errorMessage = "Firebase authentication is not available";
      });
      return;
    }
    
    // Standin implementation for Apple login that uses Firebase email/password auth
    try {
      print("Using standin Apple authentication");
      
      // Show a dialog to collect email for the standin Apple auth
      final result = await showDialog<Map<String, String>>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final TextEditingController emailController = TextEditingController();
          final TextEditingController nameController = TextEditingController();
          
          return AlertDialog(
            title: Text('Sign in with Apple'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Enter your information to simulate Apple Sign-In'),
                  SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'email': emailController.text,
                    'name': nameController.text,
                  });
                },
                child: Text('Continue'),
              ),
            ],
          );
        },
      );
      
      if (result == null || result['email']?.isEmpty == true) {
        print("Apple Sign-In canceled");
        return;
      }
      
      final String email = result['email']!;
      final String displayName = result['name'] ?? 'Apple User';
      
      // Generate a unique password based on email (this is just for simulation)
      final String password = sha256ofString(email + 'apple_auth_salt');
      
      try {
        // Try to sign in first (for returning users)
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Signed in existing Apple user: ${userCredential.user?.uid}");
      } catch (signInError) {
        // If sign in fails, create a new user
        try {
          final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          
          // Update the user profile with the display name
          await userCredential.user?.updateDisplayName(displayName);
          
          print("Created new Apple user: ${userCredential.user?.uid}");
        } catch (createError) {
          setState(() {
            _errorMessage = "Failed to create account: ${createError.toString()}";
          });
          return;
        }
      }
      
      Navigator.pushReplacementNamed(context, "/");
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to sign in with Apple: ${e.toString()}";
      });
      print("Error with Apple auth: $e");
    }
  }

  Future<void> _loginWithGoogle() async {
    if (!_isFirebaseAvailable) {
      setState(() {
        _errorMessage = "Firebase authentication is not available";
      });
      return;
    }

    try {
      print("Starting Google Sign-In process");
      // Initialize with the client ID from GoogleService-Info.plist
      final googleUser = await GoogleSignIn(
        clientId: Platform.isIOS ? "434594544336-fj4ejrdcass7aipb66h2v3tndsg8h5ku.apps.googleusercontent.com" : null,
      ).signIn();
      if (googleUser == null) {
        print("Google Sign-In was canceled");
        return;
      }
      print("Google Sign-In successful: ${googleUser.email}");

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, "/");
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to sign in with Google: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: TextButton(onPressed: () => {Navigator.pop(context)}, child: Text("Back"))
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text("Welcome Back", style: Theme.of(context).textTheme.headlineLarge),
                      Text("Please select a login method", style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.apple, size: 24),
                      label: const Text('Login with Apple'),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: _loginWithApple,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
                      label: const Text('Login with Google'),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: _loginWithGoogle,
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(_errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
