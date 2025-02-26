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

  final _passwordLoginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final emailValidator = EmailValidator(validatePurdueEmail: true);
  final passwordValidator = PasswordValidator();

  void _togglePasswordLogin(bool visibility) {
    setState(() => _showPasswordLogin = visibility);
  }

  Future<void> _loginWithApple() async {}

  Future<void> _loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _loginWithPassword() async {
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
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = getErrorMessage(e.code);
      });
    }
    setState(() => _showLoadingAnimation = false);
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
                  onPressed: _loginWithPassword,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16.0),
                if (_showLoadingAnimation) const CircularProgressIndicator() else Text(_errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
          ],
        ),
      ),
    );
  }
}
