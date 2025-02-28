import 'package:flutter/material.dart';

class _LoginSettingsPage extends State<LoginSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Settings')),
      body: Center(
        child: Column(
          children: [
            Divider(),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {},
              label: const Text('Change Password'),
            ),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {},
              label: const Text('Google'),
            ),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {},
              label: const Text('iCloud'),
            ),
            Spacer(flex: 7),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onError,
                backgroundColor: Theme.of(context).colorScheme.error,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {
                _showConfirmDialog(context);
              },
              label: const Text('Delete Account'),
            ),
            Spacer()
          ]
        )
      )
    );
  }
}

class LoginSettings extends StatefulWidget {
  const LoginSettings({super.key});

  @override
  State<LoginSettings> createState() => _LoginSettingsPage();
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