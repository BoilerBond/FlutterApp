import 'firebase_options.dart';
import 'package:datingapp/routes.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    MaterialTheme theme = MaterialTheme(context);
    return MaterialApp(routes: Routes.getRoutes(), theme: brightness == Brightness.light ? theme.light() : theme.dark());
  }
}
