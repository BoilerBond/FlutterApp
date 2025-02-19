import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showUsernameLogin = false;

  void loginWithApple() {
    // TODO: implement log in with apple
  }

  void loginWithGoogle() {
    // TODO: implement log in with google
  }

  void loginWithPassword() {
    // TODO: implement log in with username/password
  }

  void setPasswordLoginFormVisibility(bool visibility) {
    setState(() {
      _showUsernameLogin = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
        body: _showUsernameLogin
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

                          // Text field for entering the username.
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username'; // Validation for empty username.
                              }
                              return null;
                            },
                          ),

                          // Space between input fields.
                          SizedBox(height: 16.0),

                          // Text field for entering the password.
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),

                          // Space between input fields.
                          SizedBox(height: 16.0),

                          // Login button.
                          ElevatedButton(
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
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

                  // Button to switch to username/password login form.
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.key, size: 24),
                        label: Text('Login with Username/Password'),
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () => {setPasswordLoginFormVisibility(true)},
                      )),
                ])),
              ));
  }
}
