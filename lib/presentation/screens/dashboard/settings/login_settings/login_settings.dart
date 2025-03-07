import 'package:flutter/material.dart';

class LoginSettings extends StatefulWidget {
  const LoginSettings({super.key});

  @override
  State<LoginSettings> createState() => _LoginSettingsState();
}

class _LoginSettingsState extends State<LoginSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Settings'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Connected Accounts'),
            subtitle: Text('Manage your connected social accounts'),
          ),
          Divider(),
          ListTile(
            title: Text('Two-Factor Authentication'),
            subtitle: Text('Enable additional security'),
          ),
        ],
      ),
    );
  }
}
