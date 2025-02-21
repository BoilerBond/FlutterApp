import 'package:datingapp/utils/validators/email_validator.dart';
import 'package:datingapp/utils/validators/password_validator.dart';
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

  final _passwordLoginFormKey = GlobalKey<FormState>();

  // input validators
  final emailValidator = EmailValidator(validatePurdueEmail: true);
  final passwordValidator = PasswordValidator();

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
    if (_passwordLoginFormKey.currentState!.validate()) {
      // TODO: implement log in with email/password
      // TODO: navigate to dashboard
    }
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
                      key: _passwordLoginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Main title of the login screen.
                          Text("Login to Account", style: textTheme.headlineLarge),
                          Text("Please provide your email and password", style: textTheme.bodySmall),

                          SizedBox(height: 16.0),

                          // Text field for entering the email.
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            validator: emailValidator.validate,
                          ),

                          // Space between input fields.
                          SizedBox(height: 16.0),

                          // Text field for entering the password.
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: passwordValidator.validate,
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
                  Text("Welcome Back", style: textTheme.headlineLarge),
                  Text("Please select a login method", style: textTheme.bodySmall),

                  // Space below the title.
                  SizedBox(height: 16.0),

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
