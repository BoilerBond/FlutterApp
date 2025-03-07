import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/presentation/screens/app_description/app_description_screen.dart';
import 'package:datingapp/presentation/screens/start/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A widget that acts as a middleware to check the authentication state of the user.
///
/// This widget listens for authentication state changes using
/// `FirebaseAuth` and determines whether the user is authenticated or not. If the user is
/// authenticated, it will display the child widget passed to it. If the user is not authenticated,
/// it will redirect to the `LoginScreen` to allow the user to sign in.
class AuthMiddleware extends StatefulWidget {
  final Widget child;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  AuthMiddleware({required this.child});

  @override
  _AuthMiddlewareState createState() => _AuthMiddlewareState();
}

class _AuthMiddlewareState extends State<AuthMiddleware> {
  Stream<bool> checkProfileExists(String uid) {
    return widget.db.collection("users").doc(uid).snapshots().map((snapshot) => snapshot.exists);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return StreamBuilder<bool>(
              stream: checkProfileExists(user.uid),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (profileSnapshot.hasData && profileSnapshot.data!) {
                  return widget.child;
                } else {
                  return AppDescriptionScreen(navigatePath: "/purdue_verification", navigateToTos: true);
                }
              },
            );
          } else {
            return StartScreen();
          }
        });
  }
}