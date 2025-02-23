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
              label: const Text('Placeholder buttons'),
            ),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {},
              label: const Text('Placeholder buttons'),
            ),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {},
              label: const Text('Placeholder buttons'),
            ),
            Spacer(flex: 7),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onError,
                backgroundColor: Theme.of(context).colorScheme.error,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {},
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
  const LoginSettings();

  @override
  State<LoginSettings> createState() => _LoginSettingsPage();
}