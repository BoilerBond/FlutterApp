import 'package:flutter/material.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool _isNotificationsEnabled = false;

  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(title: const Text('Enable notifications'), value: _isNotificationsEnabled, activeTrackColor: Theme.of(context).colorScheme.primary, onChanged: _toggleNotifications)
          ],
        ),
      ),
    );
  }
}
