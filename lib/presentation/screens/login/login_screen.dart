import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:datingapp/utils/validators/email_validator.dart';
import 'package:datingapp/utils/validators/password_validator.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
    // Apple login implementation would go here
    try {
      String clientId = "com.boilerbond"; // TODO: register client id in apple developer account
      String redirectUri = "https://spiced-furry-crow.glitch.me/callbacks/sign_in_with_apple";

      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: Platform.isIOS ? nonce : null,
        webAuthenticationOptions: Platform.isIOS ? null : WebAuthenticationOptions(clientId: clientId, redirectUri: Uri.parse(redirectUri)),
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      Navigator.pushReplacementNamed(context, "/");
      print("User: ${userCredential.user?.uid}");
    } catch (e) {
      print("Error: $e");
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
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

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
