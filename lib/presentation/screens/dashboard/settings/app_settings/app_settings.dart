import 'package:flutter/material.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool _notificationsEnabled = false;
  bool _matchResultNotificationEnabled = false;
  bool _messageNotificationEnabled = false;
  bool _eventsNotificationsEnabled = false;

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
      _matchResultNotificationEnabled = value;
      _messageNotificationEnabled = value;
      _eventsNotificationsEnabled = value;
    });
  }

  void _toggleMatchResultNotifications(bool value) {
    setState(() {
      _matchResultNotificationEnabled = value;
    });
  }
  
  void _toggleMessageNotifications(bool value) {
    setState(() {
      _messageNotificationEnabled = value;
    });
  }

  void _toggleEventsNotifications(bool value) {
    setState(() {
      _eventsNotificationsEnabled = value;
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
            SwitchListTile(title: const Text('Notifications'), value: _notificationsEnabled, activeTrackColor: Theme.of(context).colorScheme.primary, onChanged: _toggleNotifications),
            _notificationsEnabled ? Column(
              children: [
                SwitchListTile(title: const Text('Match result notifications'), value: _matchResultNotificationEnabled, activeTrackColor: Theme.of(context).colorScheme.primary, onChanged: _toggleMatchResultNotifications),
                SwitchListTile(title: const Text('Messaging notifications'), value: _messageNotificationEnabled, activeTrackColor: Theme.of(context).colorScheme.primary, onChanged: _toggleMessageNotifications),
                SwitchListTile(title: const Text('Event notifications'), value: _eventsNotificationsEnabled, activeTrackColor: Theme.of(context).colorScheme.primary, onChanged: _toggleEventsNotifications)
              ],
            ) : Container()
          ],
        ),
      ),
    );
  }
}
