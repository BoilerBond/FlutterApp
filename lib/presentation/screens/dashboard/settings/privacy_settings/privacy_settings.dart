import 'package:flutter/material.dart';

class _PrivacySettingsPage extends State<PrivacySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
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
            Spacer(flex: 10)
          ]
        )
      )
    );
  }
}

class PrivacySettings extends StatefulWidget {
  const PrivacySettings();

  @override
  State<PrivacySettings> createState() => _PrivacySettingsPage();
}
