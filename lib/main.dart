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
     home: MyHomePage(title: "Flutter Demo Home Page"),
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
      
      // Check if user already exists
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      print('Sign-in methods for $email: $methods');
      
      if (methods.isNotEmpty) {
        // User exists, send password reset email as a way to verify
        print('User exists, sending password reset email');
        await _auth.sendPasswordResetEmail(email: email);
        print('Password reset email sent successfully');
      } else {
        // Create new user with a random password
        print('Creating new user with email: $email');
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        
        print('User created successfully: ${userCredential.user?.uid}');
        
        // Send email verification
        print('Sending email verification');
        await userCredential.user?.sendEmailVerification();
        print('Email verification sent successfully');
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Verification email sent!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors with more detailed information
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String errorMessage = "An error occurred. Please try again.";
      
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already in use.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = "Email/password accounts are not enabled.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many requests. Try again later.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "This user account has been disabled.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'network-request-failed') {
        errorMessage = "Network error. Check your internet connection.";
      }
      
      // Show detailed error in console
      print('Showing error message to user: $errorMessage');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$errorMessage (Error code: ${e.code})"),
            backgroundColor: Colors.red,
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
          ],
        ),
      ),
    );
  }
}

