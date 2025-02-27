import 'package:datingapp/presentation/widgets/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginSettings extends StatefulWidget {
  const LoginSettings({super.key});

  @override
  State<LoginSettings> createState() => LoginSettingsPage();
}

class LoginSettingsPage extends State<LoginSettings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Settings')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _onChangePurdueEmailPress(context),
                      child: Text("Change Purdue Email"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _onChangePasswordPress(context),
                      child: Text("Change Password"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        foregroundColor: Theme.of(context).colorScheme.errorContainer,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _onLogoutPress(context),
                      child: Text("Log Out"),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _onDeleteAccountPress(context),
                child: Text(
                  'Delete Account',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChangePurdueEmailPress(BuildContext context) {}

  void _onChangePasswordPress(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/settings/login/change_password");
  }

  void _onLogoutPress(BuildContext context) {
    confirmDialog(context, () async {
      await FirebaseAuth.instance.signOut();
    });
  }

  void _onDeleteAccountPress(BuildContext context) {
    confirmDialog(context, () async {
      // TODO: delete user information in Firebase

      await FirebaseAuth.instance.signOut();
    });
  }
}
