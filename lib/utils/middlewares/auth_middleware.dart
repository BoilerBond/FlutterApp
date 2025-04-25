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

  AuthMiddleware({super.key, required this.child});

  @override
  _AuthMiddlewareState createState() => _AuthMiddlewareState();
}

class _AuthMiddlewareState extends State<AuthMiddleware> {
  Stream<bool> checkProfileExists(String uid) {
    return widget.db.collection("users").doc(uid).snapshots().map((snapshot) => snapshot.exists);
  }

  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Handle connection errors
            if (snapshot.hasError) {
              print('Auth state stream error: ${snapshot.error}');
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Authentication error occurred'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text('Retry'),
                      )
                    ],
                  ),
                ),
              );
            }
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading BoilerBond...'),
                  ],
                )),
              );
            }
            
            if (snapshot.hasData) {
              final user = snapshot.data!;
              print('User authenticated: ${user.uid}');
              
              return StreamBuilder<bool>(
                stream: checkProfileExists(user.uid),
                builder: (context, profileSnapshot) {
                  // Handle profile stream errors
                  if (profileSnapshot.hasError) {
                    print('Profile check error: ${profileSnapshot.error}');
                    return Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error checking profile'),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              child: Text('Retry'),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  
                  if (profileSnapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading profile...'),
                        ],
                      )),
                    );
                  }

                  if (profileSnapshot.hasData && profileSnapshot.data!) {
                    print('User profile exists, showing main content');
                    return widget.child;
                  } else {
                    print('User profile does not exist, showing onboarding');
                    // return widget.child;
                    return AppDescriptionScreen(arguments: {
                      "navigatePath": "/purdue_verification",
                      "navigateToTos": true
                    });
                  }
                },
              );
            } else {
              print('No authenticated user, showing start screen');
              return StartScreen();
            }
          });
    } catch (e) {
      print('Unexpected error in AuthMiddleware: $e');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('BoilerBond'),
              SizedBox(height: 20),
              Text('An unexpected error occurred'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text('Retry'),
              )
            ],
          ),
        ),
      );
    }
  }
}