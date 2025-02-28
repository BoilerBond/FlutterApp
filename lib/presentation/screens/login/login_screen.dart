import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:datingapp/utils/validators/email_validator.dart';
import 'package:datingapp/utils/validators/password_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPasswordLogin = false;
  bool _showLoadingAnimation = false;
  String _errorMessage = "";
  bool _isFirebaseAvailable = true;

  final _passwordLoginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final emailValidator = EmailValidator(validatePurdueEmail: true);
  final passwordValidator = PasswordValidator();

  @override
  void initState() {
    super.initState();
    _checkFirebaseAvailability();
  }

  void _checkFirebaseAvailability() {
    try {
      FirebaseAuth.instance.authStateChanges();
      setState(() {
        _isFirebaseAvailable = true;
      });
    } catch (e) {
      setState(() {
        _isFirebaseAvailable = false;
      });
      print("Firebase auth error: $e");
    }
    
  void navigateToDashboard() {
    Navigator.pushReplacementNamed(context, "/");
  }

  void _togglePasswordLogin(bool visibility) {
    setState(() => _showPasswordLogin = visibility);
  }

  Future<void> _loginWithApple() async {
    if (!_isFirebaseAvailable) {
      setState(() {
        _errorMessage = "Firebase authentication is not available";
      });
      return;
    }
    // Apple login implementation would go here
    setState(() {
      _errorMessage = "Apple login not implemented yet";
    });
  }

  Future<void> _loginWithGoogle() async {
    if (!_isFirebaseAvailable) {
      setState(() {
        _errorMessage = "Firebase authentication is not available";
      });
      return;
    }

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

// <<<<<<< code for email verification via firebase for purdue emails
//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final user = await FirebaseAuth.instance.signInWithCredential(credential);
//       bool isNewUser = user.additionalUserInfo?.isNewUser ?? true;
//       bool hasProfile = true; // TODO: check if user profile exists

//       _navigateToNextScreen(user.additionalUserInfo?.isNewUser ?? true && hasProfile);
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Failed to sign in with Google: ${e.toString()}";
//       });
//     }
// =======
    await FirebaseAuth.instance.signInWithCredential(credential);
    navigateToDashboard();
  }

  Future<void> _loginWithPassword() async {
    if (!_isFirebaseAvailable) {
      setState(() {
        _errorMessage = "Firebase authentication is not available";
      });
      return;
    }

    String getErrorMessage(String errorCode) {
      switch (errorCode) {
        case "invalid-credential":
          return "Invalid email or password";
        case "network-request-failed":
          return "Failed to connect to the server";
        default:
          return "An unexpected error occurred";
      }
    }

    if (!_passwordLoginFormKey.currentState!.validate()) return;

    setState(() => _showLoadingAnimation = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = getErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error occurred: ${e.toString()}";
      });
    }
    setState(() => _showLoadingAnimation = false);
  }

  void _demoLogin() {
    // For demo purposes, navigate to the Purdue verification screen
    Navigator.pushReplacementNamed(context, "/purdue_verification");
  }

  void _navigateToNextScreen(bool isNewUser) {
    if (isNewUser) {
      // TODO: Navigate to app description and terms and conditions screen
      Navigator.pushReplacementNamed(context, "/purdue_verification");
    } else {
      // Check if user has verified Purdue email
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.email != null && 
          currentUser.email!.endsWith('@purdue.edu') && 
          currentUser.emailVerified) {
        // User has verified Purdue email, go to dashboard
        Navigator.pushReplacementNamed(context, "/dashboard");
      } else {
        // User needs to verify Purdue email
        Navigator.pushReplacementNamed(context, "/purdue_verification");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showPasswordLogin ? _buildPasswordLoginForm() : _buildLoginOptions(),
    );
  }

  //The widget displaying email/password login form
  Widget _buildPasswordLoginForm() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _passwordLoginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text("Login to Account", style: Theme.of(context).textTheme.headlineLarge),
                    Text("Please provide your email and password", style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: emailValidator.validate,
                  onChanged: (value) => setState(() => _errorMessage = ""),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: passwordValidator.validate,
                  obscureText: true,
                  onChanged: (value) => setState(() => _errorMessage = ""),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: _isFirebaseAvailable ? _loginWithPassword : _demoLogin,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16.0),
                if (_showLoadingAnimation) 
                  const CircularProgressIndicator() 
                else 
                  Text(_errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: TextButton(onPressed: () => _togglePasswordLogin(false), child: const Text("Back")),
        ),
      ],
    );
  }

  // The widget displaying all available login options
  Widget _buildLoginOptions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text("Welcome Back", style: Theme.of(context).textTheme.headlineLarge),
                Text("Please select a login method", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.apple, size: 24),
                label: const Text('Login with Apple'),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: _loginWithApple,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
                label: const Text('Login with Google'),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: _loginWithGoogle,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.key, size: 24),
                label: const Text('Login with Email/Password'),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => _togglePasswordLogin(true),
              ),
            ),
            if (!_isFirebaseAvailable)
              Column(
                children: [
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.preview, size: 24),
                      label: const Text('Demo Login (Without Firebase)'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: _demoLogin,
                    ),
                  ),
                ],
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(_errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
    );
  }
}
