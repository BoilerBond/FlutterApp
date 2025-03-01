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

  // Method to send verification email
  Future<void> sendVerificationEmail(String email) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Print debug info
      print('Attempting to verify email: $email');
      
      // Generate a verification code
      final verificationCode = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
      
      // Store the verification code in Firestore (you'll need to add Firestore dependency)
      // For now, we'll just print it
      print('Generated verification code: $verificationCode for $email');
      
      // In a real app, you would store this in Firestore:
      // await FirebaseFirestore.instance.collection('emailVerifications').doc(email).set({
      //   'code': verificationCode,
      //   'createdAt': FieldValue.serverTimestamp(),
      //   'verified': false
      // });
      
      // Send a custom verification email using Firebase Functions or your own email service
      // For now, we'll simulate this with a success message
      print('Would send verification email to $email with code: $verificationCode');
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification email would be sent to $email. For testing, use code: $verificationCode"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 8),
          ),
        );
        
        // Navigate to verification code entry screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen(
              email: email,
              expectedCode: verificationCode,
            ),
          ),
        );
      }
    } catch (e) {
      // Handle other errors with more details
      print('General exception: ${e.toString()}');
      
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
              "Please enter your Purdue email address to verify your account.",
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
                      // Valid Purdue email, send verification email
                      sendVerificationEmail(email);
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
                : const Text('Send Verification Email'),
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
                foregroundColor: Colors.black,
              ),
              child: const Text('Check Firebase Connection'),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this new class at the end of the file
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
      // Check if the link is a sign-in with email link
      if (_auth.isSignInWithEmailLink(Uri.base.toString())) {
        setState(() {
          message = "Processing your verification...";
        });

        // You would normally get this from shared preferences or local storage
        // For demo purposes, we'll extract it from the URL
        final uri = Uri.parse(Uri.base.toString());
        final email = uri.queryParameters['email'];

        if (email != null) {
          // Sign in with email link
          final userCredential = await _auth.signInWithEmailLink(
            email: email,
            emailLink: Uri.base.toString(),
          );

          setState(() {
            isVerifying = false;
            isSuccess = true;
            message = "Email verified successfully! You can now use the app.";
          });

          print("User signed in: ${userCredential.user?.uid}");
        } else {
          setState(() {
            isVerifying = false;
            message = "Could not find email parameter in the link.";
          });
        }
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
                const CircularProgressIndicator()
              else
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 80,
                ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: const Text("Return to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add this new class at the end of the file
class VerificationCodeScreen extends StatefulWidget {
  final String email;
  final String expectedCode;

  const VerificationCodeScreen({
    super.key, 
    required this.email, 
    required this.expectedCode
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  bool isVerifying = false;
  bool isVerified = false;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> verifyCode() async {
    final enteredCode = codeController.text.trim();
    
    if (enteredCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the verification code"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isVerifying = true;
    });

    try {
      // In a real app, you would verify against Firestore or your backend
      // For now, we'll just compare with the expected code
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      if (enteredCode == widget.expectedCode) {
        // Code is correct
        setState(() {
          isVerified = true;
        });
        
        // In a real app, you would update Firestore and create a user record
        print('Email verified successfully: ${widget.email}');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email verified successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        
        // Wait a moment before navigating
        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          // Navigate to the main app or profile creation
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainNavigation()),
            (route) => false,
          );
        }
      } else {
        // Code is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid verification code. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error verifying code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Your Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter Verification Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "We've sent a verification code to ${widget.email}. Please enter it below.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: "Verification Code",
                hintText: "Enter the code sent to your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.security),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVerifying || isVerified ? null : verifyCode,
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
              child: isVerifying 
                ? const CircularProgressIndicator() 
                : isVerified
                  ? const Text('Verified ✓')
                  : const Text('Verify Code'),
            ),
            const SizedBox(height: 20),
            // Debug info
            Text(
              "Debug: Expected code is ${widget.expectedCode}",
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

