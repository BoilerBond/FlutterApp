import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPasswordLogin = false;

  // input controller for password login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void setPasswordLoginFormVisibility(bool visibility) {
    setState(() {
      _showPasswordLogin = visibility;
    });
  }

  void loginWithApple() {
    // TODO: implement log in with apple
  }

  Future<void> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
    bool isNewUser = user.additionalUserInfo?.isNewUser ?? true;
    navigateToNextScreen(isNewUser);
  }

  void loginWithPassword() {
    // TODO: implement log in with email/password
    // TODO: navigate to dashboard
  }

  void navigateToNextScreen(bool isNewUser) {
    if (isNewUser) {
      // TODO: navigate to app description & terms and conditions
      // the app should skip sign up screen directly to purdue email verification since user is authenticated
    } else {
      // TODO: navigate to dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
        body: _showPasswordLogin
            ? Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Main title of the login screen.
                          Text("Login", style: Theme.of(context).textTheme.headlineLarge),

                          // Text field for entering the email.
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              final bool emailValid = value != null && RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value);
                              return emailValid ? null : "Please enter an email";
                            },
                          ),

                          // Space between input fields.
                          SizedBox(height: 16.0),

                          // Text field for entering the password.
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              return (value != null && value.isNotEmpty) ? null : 'Please enter a password';
                            },
                          ),

                          // Space between input fields.
                          SizedBox(height: 16.0),

                          // Login button.
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: loginWithPassword,
                            child: Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Positioned widget to place the "Back" button at the bottom left of the screen.
                  Positioned(
                    top: 5,
                    left: 5,
                    child: TextButton(
                      onPressed: () => {setPasswordLoginFormVisibility(false)},
                      child: Text("Back"),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  // Main title of the login screen.
                  Text("Login", style: textTheme.headlineLarge),

                  // Space below the title.
                  SizedBox(height: 10),

                  // Button for Apple login.
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.apple, size: 24),
                        label: Text('Login with Apple'),
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: loginWithApple,
                      )),

                  // Button for Google login.
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.g_mobiledata_rounded, size: 24),
                        label: Text('Login with Google'),
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: loginWithGoogle,
                      )),

                  // Button to switch to email/password login form.
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.key, size: 24),
                        label: Text('Login with Email/Password'),
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () => {setPasswordLoginFormVisibility(true)},
                      )),
                ])),
              ));
  }
}
