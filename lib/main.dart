import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'package:datingapp/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:datingapp/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:datingapp/utils/firebase_emulator_utils.dart';

import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Use emulators in debug mode or when explicitly requested
  if (kDebugMode || const bool.fromEnvironment("USE_FIREBASE_EMULATOR")) {
    configureFirebaseEmulators();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    MaterialTheme theme = MaterialTheme(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoutes(), 
      theme: brightness == Brightness.light ? theme.light() : theme.dark()
    );
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
  debugPrint('Using Firebase Auth emulator on: $host:$port');
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
  debugPrint('Using Firebase Firestore emulator on: $host:$port');
}

void _configureFirebaseFunctions() {
  String configHost = const String.fromEnvironment("FIREBASE_EMULATOR_URL");
  int configPort = const int.fromEnvironment("FUNCTIONS_EMULATOR_PORT");
  var defaultHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  var host = configHost.isNotEmpty ? configHost : defaultHost;
  var port = configPort != 0 ? configPort : 5001;

  FirebaseFunctions.instance.useFunctionsEmulator(host, port);
  debugPrint('Using Firebase Functions emulator on: $host:$port');
}