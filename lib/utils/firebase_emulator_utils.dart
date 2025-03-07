import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Configure Firebase to use emulators when in debug mode
void configureFirebaseEmulators() async {
  if (kDebugMode) {
    const String host = '127.0.0.1';
    
    // Configure Auth Emulator
    await _configureFirebaseAuth();
    
    // Configure Firestore Emulator
    _configureFirebaseFirestore();
    
    // Configure Cloud Functions Emulator
    _configureFirebaseFunctions();
  }
} 

// Keep existing emulator configuration methods for backward compatibility
Future<void> _configureFirebaseAuth() async {
  String configHost = const String.fromEnvironment("FIREBASE_EMULATOR_URL");
  int configPort = const int.fromEnvironment("AUTH_EMULATOR_PORT");
  var defaultHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  var host = configHost.isNotEmpty ? configHost : defaultHost;
  var port = configPort != 0 ? configPort : 9099;
  await FirebaseAuth.instance.useAuthEmulator(host, port);
  debugPrint('🔥 Using Firebase Auth emulator on: $host:$port');
}

void _configureFirebaseFirestore() {
  String configHost = const String.fromEnvironment("FIREBASE_EMULATOR_URL");
  int configPort = const int.fromEnvironment("FIRESTORE_EMULATOR_PORT");
  var defaultHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  var host = configHost.isNotEmpty ? configHost : defaultHost;
  var port = configPort != 0 ? configPort : 8080;

  FirebaseFirestore.instance.settings = Settings(
    host: '$host:$port',
    sslEnabled: false,
    persistenceEnabled: false,
  );
  debugPrint('🔥 Using Firebase Firestore emulator on: $host:$port');
}

void _configureFirebaseFunctions() {
  String configHost = const String.fromEnvironment("FIREBASE_EMULATOR_URL");
  int configPort = const int.fromEnvironment("FUNCTIONS_EMULATOR_PORT");
  var defaultHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  var host = configHost.isNotEmpty ? configHost : defaultHost;
  var port = configPort != 0 ? configPort : 5001;

  FirebaseFunctions.instance.useFunctionsEmulator(host, port);
  debugPrint('🔥 Using Firebase Functions emulator on: $host:$port');
}