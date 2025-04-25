import 'firebase_options.dart';
import 'package:datingapp/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:datingapp/theme/theme.dart';
import 'package:datingapp/utils/firebase_emulator_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Use emulators in debug mode or when explicitly requested
    if (const bool.fromEnvironment("USE_FIREBASE_EMULATOR")) {
      configureFirebaseEmulators();
    }

    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Run app even if Firebase fails to initialize
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final brightness = View.of(context).platformDispatcher.platformBrightness;
      MaterialTheme theme = MaterialTheme(context);

      return MaterialApp(
        title: 'BoilerBond',
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        initialRoute: "/",
        onGenerateRoute: (settings) {
          try {
            return Routes.onGenerateRoute(settings);
          } catch (e) {
            print('Error in route generation: $e');
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error loading app: $e'),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/'),
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
        debugShowCheckedModeBanner: false,
      );
    } catch (e) {
      print('Error in MyApp.build: $e');
      // Fallback UI in case of errors
      return MaterialApp(
        title: 'BoilerBond',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('BoilerBond'),
                SizedBox(height: 20),
                Text('Error initializing app. Please restart.'),
              ],
            ),
          ),
        ),
      );
    }
  }
}
