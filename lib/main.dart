import "package:datingapp/presentation/screens/main%20navigation/main_nav.dart";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('Initializing Firebase with options: ${DefaultFirebaseOptions.currentPlatform}');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
    print('Firebase Auth instance: ${FirebaseAuth.instance}');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 // This widget is the root of your application.
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: "Boiler Bond",
     theme: ThemeData(
       // This is the theme of your application.
       //
       // TRY THIS: Try running your application with "flutter run". You"ll see
       // the application has a purple toolbar. Then, without quitting the app,
       // try changing the seedColor in the colorScheme below to Colors.green
       // and then invoke "hot reload" (save your changes or press the "hot
       // reload" button in a Flutter-supported IDE, or press "r" if you used
       // the command line to start the app).
       //
       // Notice that the counter didn"t reset back to zero; the application
       // state is not lost during the reload. To reset the state, use hot
       // restart instead.
       //
       // This works for code too, not just values: Most code changes can be
       // tested with just a hot reload.
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
       useMaterial3: true,
     ),
     // Check if the app was opened with an email sign-in link
     initialRoute: '/',
     routes: {
       '/': (context) => MyHomePage(title: "Flutter Demo Home Page"),
       '/verify-email': (context) => const EmailVerificationHandler(),
     },
     onGenerateRoute: (settings) {
       // Handle deep links for email verification
       if (settings.name != null && settings.name!.startsWith('/finishSignUp')) {
         return MaterialPageRoute(
           builder: (context) => const EmailVerificationHandler(),
           settings: settings,
         );
       }
       return null;
     },
   );
 }
}

class MyHomePage extends StatelessWidget {
 final String title;
 const MyHomePage({super.key, required this.title});

 @override
 Widget build(BuildContext context) {
   return Scaffold(
    body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Boiler Bond',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[400],
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  'Form deeper bonds.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 228, 245),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 228, 245),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 228, 245),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('About'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigation()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 228, 245),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Main Navigation'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class LoginPage extends StatelessWidget {
 const LoginPage({super.key});

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Login"),
     ),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const Text("Login page"),
           const SizedBox(height: 20),
           ElevatedButton(
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const PurdueVerificationPage()),
               );
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: const Color.fromARGB(255, 183, 228, 245),
               foregroundColor: Colors.black,
               padding: const EdgeInsets.symmetric(
                 horizontal: 40,
                 vertical: 16,
               ),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
               ),
             ),
             child: const Text('Verify Purdue Email'),
           ),
         ],
       ),
     ),
   );
 }
}

class RegisterPage extends StatelessWidget {
 const RegisterPage({super.key});

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Register"),
     ),
     body: const Center(
       child: Text("Register page"),
     ),
   );
 }
}

class AboutPage extends StatelessWidget {
 const AboutPage({super.key});

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("About Boiler Bond"),
     ),
     body: const Center(
       child: Padding(
         padding: EdgeInsets.all(10.0),
         child: Text(
           "Add about text here",
           textAlign: TextAlign.center,
         ),
       ),
     ),
   );
 }
}

class PurdueVerificationPage extends StatefulWidget {
  const PurdueVerificationPage({super.key});

  @override
  State<PurdueVerificationPage> createState() => _PurdueVerificationPageState();
}

class _PurdueVerificationPageState extends State<PurdueVerificationPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to send passwordless sign-in link
  Future<void> sendSignInLinkToEmail(String email) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Configure the action code settings
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://boilerbond.page.link/verify?email=$email',
        handleCodeInApp: true,
        androidPackageName: 'com.example.boilerbond',
        androidInstallApp: true,
        androidMinimumVersion: '12',
        iOSBundleId: 'com.example.boilerbond',
      );
      
      // Send the sign-in link to the user's email
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      
      // Store the email locally to use it when the user clicks on the link
      // In a real app, you'd store this in SharedPreferences
      print('Email for sign-in: $email');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification email sent to $email. Check your inbox."),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 8),
          ),
        );
        
        // Show a success message with instructions
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Email Sent"),
            content: Text(
              "We've sent a verification link to $email.\n\n"
              "Please check your email and click the link to verify your Purdue email address."
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error sending email verification link: ${e.toString()}');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purdue Email Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Verify your Purdue Email",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Please enter your Purdue email address. We'll send you a verification link to confirm your account.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Purdue Email",
                hintText: "example@purdue.edu",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading 
                ? null 
                : () {
                    // Get the email value from the controller
                    final email = emailController.text.trim();
                    
                    // Check if the email is valid and is a Purdue email
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter an email address"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (!email.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid email address"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (!email.toLowerCase().endsWith('@purdue.edu')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid Purdue email address (@purdue.edu)"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Valid Purdue email, send verification link
                      sendSignInLinkToEmail(email);
                    }
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 183, 228, 245),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading 
                ? const CircularProgressIndicator() 
                : const Text('Send Verification Link'),
            ),
            const SizedBox(height: 20),
            // Debug section
            const Divider(),
            const Text(
              "Debug Options",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                try {
                  final authInstance = FirebaseAuth.instance;
                  final message = 'Firebase Auth is ${authInstance != null ? "initialized" : "NOT initialized"}\n'
                      'Current user: ${authInstance.currentUser?.email ?? "No user signed in"}';
                  
                  print(message);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.blue,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                } catch (e) {
                  print('Debug button error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Firebase error: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
              ),
              child: const Text('Check Firebase Connection'),
            ),
          ],
        ),
      ),
    );
  }
}

// Email verification handler for when users click the link in their email
class EmailVerificationHandler extends StatefulWidget {
  const EmailVerificationHandler({super.key});

  @override
  State<EmailVerificationHandler> createState() => _EmailVerificationHandlerState();
}

class _EmailVerificationHandlerState extends State<EmailVerificationHandler> {
  bool isVerifying = true;
  bool isSuccess = false;
  String message = "Verifying your email...";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _handleEmailLink();
  }

  Future<void> _handleEmailLink() async {
    try {
      final currentUrl = Uri.base.toString();
      // Check if the link is a sign-in with email link
      if (_auth.isSignInWithEmailLink(currentUrl)) {
        setState(() {
          message = "Processing your verification...";
        });

        // Extract email from URL parameters
        final uri = Uri.parse(currentUrl);
        String? email = uri.queryParameters['email'];

        // If email not in URL, prompt user to enter it
        if (email == null) {
          // In a real app, you'd try to get it from SharedPreferences first
          setState(() {
            isVerifying = false;
            message = "Please enter your email to complete verification";
          });
          return;
        }

        // Verify that it's a Purdue email
        if (!email.toLowerCase().endsWith('@purdue.edu')) {
          setState(() {
            isVerifying = false;
            isSuccess = false;
            message = "Only Purdue email addresses can be verified.";
          });
          return;
        }

        // Sign in with email link
        final userCredential = await _auth.signInWithEmailLink(
          email: email,
          emailLink: currentUrl,
        );

        final user = userCredential.user;
        
        // Update user profile with display name from email (optional)
        if (user != null) {
          final displayName = email.split('@')[0]; // username part of email
          await user.updateDisplayName(displayName);
          
          // You could also store additional info in Firestore
          // await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          //   'email': email,
          //   'isPurdueVerified': true,
          //   'verifiedAt': FieldValue.serverTimestamp(),
          // });
        }

        setState(() {
          isVerifying = false;
          isSuccess = true;
          message = "Email verified successfully! You can now use the app.";
        });

        print("User signed in: ${userCredential.user?.uid}");
      } else {
        setState(() {
          isVerifying = false;
          message = "This is not a valid email verification link.";
        });
      }
    } catch (e) {
      print("Error during email verification: $e");
      setState(() {
        isVerifying = false;
        message = "Error verifying email: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isVerifying)
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              if (!isVerifying)
                ElevatedButton(
                  onPressed: () {
                    if (isSuccess) {
                      // Navigate to the main app screen
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const MainNavigation()),
                        (route) => false,
                      );
                    } else {
                      // Go back to the home screen
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(title: "Flutter Demo Home Page"),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 228, 245),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isSuccess ? 'Continue to App' : 'Go Back'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

