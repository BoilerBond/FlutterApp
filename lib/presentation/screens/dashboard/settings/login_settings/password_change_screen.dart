import 'package:datingapp/utils/validators/password_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String message = "";
  bool successful = true;
  bool loading = false;

  final _passwordValidator = PasswordValidator();

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

  void _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        setState(() {
          successful = false;
          message = "New password and confirm password do not match";
        });
      } else {
        setState(() {
          loading = true;
          message = "";
        });
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          try {
            final AuthCredential credential = EmailAuthProvider.credential(
              email: user.email!,
              password: _oldPasswordController.text,
            );

            await user.reauthenticateWithCredential(credential);
            await user.updatePassword(_newPasswordController.text);

            setState(() {
              successful = true;
              message = "Password changed successfully";
            });
          } on FirebaseAuthException catch (e) {
            setState(() {
              successful = false;
              message = getErrorMessage(e.code);
            });
          }
        }
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Old Password'),
                validator: _passwordValidator.validate,
              ),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: _passwordValidator.validate,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                validator: _passwordValidator.validate,
              ),
              SizedBox(height: 20),
              loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _changePassword,
                      child: Text('Change Password'),
                    ),
              Text(
                message,
                style: TextStyle(color: successful ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error),
              )
            ],
          ),
        ),
      ),
    );
  }
}
