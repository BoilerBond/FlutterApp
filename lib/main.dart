import 'firebase_options.dart';
import 'package:datingapp/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:datingapp/theme/theme.dart';
import 'package:datingapp/utils/firebase_emulator_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env file
  await dotenv.load(fileName: ".env");
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Use emulators in debug mode or when explicitly requested
  if (const bool.fromEnvironment("USE_FIREBASE_EMULATOR")) {
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
      title: 'BoilerBond Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        return Routes.onGenerateRoute(settings);
      },
    );
  }
}
