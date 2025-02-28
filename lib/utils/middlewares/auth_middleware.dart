import 'package:datingapp/presentation/screens/login/login_screen.dart';
import 'package:datingapp/presentation/screens/purdue_verification/purdue_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A widget that acts as a middleware to check the authentication state of the user.
/// 
/// This widget listens for authentication state changes using
/// `FirebaseAuth` and determines whether the user is authenticated or not. If the user is 
/// authenticated, it will display the child widget passed to it. If the user is not authenticated,
/// it will redirect to the `LoginScreen` to allow the user to sign in.
class AuthMiddleware extends StatelessWidget {
  final Widget child;

  AuthMiddleware({required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // TODO: If the user does not have profile data set up (purdue email not verified), return to app description and TOS screen
          bool hasProfile = true;
          if (!hasProfile) {
            // TODO: change this to app description and TOS screen
            return PurdueVerificationScreen();
          } else {
            return child;
          }
        } else {
          // TODO: Return home screen instead of login
          return LoginScreen();
        }
      },
    );
  }
}
