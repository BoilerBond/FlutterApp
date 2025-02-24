import 'package:flutter/material.dart';

class LoginSettings extends StatefulWidget {
  const LoginSettings({super.key});

  @override
  State<LoginSettings> createState() => LoginSettingsPage();
}

class LoginSettingsPage extends State<LoginSettings> {
  @override
  Widget build(BuildContext context) {
    // List of buttons except delete account
    final List<Map<String, dynamic>> buttons = [
      {'title': 'Change Password', 'onPressed': (BuildContext context) => _onChangePasswordPress(context)},
      {'title': 'Google', 'onPressed': (BuildContext context) => _onGoogleSettingsPress(context)},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Login Settings')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: buttons
                    .map(
                      (button) => Padding(
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
                            onPressed: () => button['onPressed'](context),
                            child: Text(button['title'] as String),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
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

  void _onChangePasswordPress(BuildContext context) {}

  void _onGoogleSettingsPress(BuildContext context) {}

  void _onDeleteAccountPress(BuildContext context) {
    _showConfirmDialog(context);
  }
}

Future<bool> _showConfirmDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  // delete user information in Firebase
                  // log out user
                },
              ),
            ],
          );
        },
      ) ??
      false;
}
