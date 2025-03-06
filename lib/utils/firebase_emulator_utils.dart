import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Configure Firebase to use emulators when in debug mode
void configureFirebaseEmulators() {
  if (kDebugMode) {
    const String host = '127.0.0.1';
    
    // Configure Auth Emulator
    FirebaseAuth.instance.useAuthEmulator(host, 9099);
    debugPrint('🔥 Using Firebase Auth Emulator');
    
    // Configure Firestore Emulator
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    debugPrint('🔥 Using Firebase Firestore Emulator');
    
    // Configure Cloud Functions Emulator
    FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
    debugPrint('🔥 Using Firebase Functions Emulator');
  }
} 