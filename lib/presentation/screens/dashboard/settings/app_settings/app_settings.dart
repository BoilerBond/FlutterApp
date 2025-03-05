import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  bool _notificationsEnabled = false;
  bool _matchResultNotificationEnabled = false;
  bool _messageNotificationEnabled = false;
  bool _eventsNotificationsEnabled = false;

  Future<void> _getInitialNotificationState() async {
    if (currentUser != null) {
      final userSnapshot = await db.collection("users").doc(currentUser?.uid).get();
      final user = AppUser.fromSnapshot(userSnapshot);
      setState(() {
        _matchResultNotificationEnabled = user.matchResultNotificationEnabled;
        _messageNotificationEnabled = user.messagingNotificationEnabled;
        _eventsNotificationsEnabled = user.eventNotificationEnabled;
        _notificationsEnabled = _matchResultNotificationEnabled || _messageNotificationEnabled || _eventsNotificationsEnabled;
      });
    }
  }

  Future<void> _updateNotificationSetting() async {
    if (currentUser != null) {
      final callable = FirebaseFunctions.instance.httpsCallable('user-notifications-changeNotificationSettings');
      await callable.call({
        "matchResultNotificationEnabled": _matchResultNotificationEnabled,
        "messagingNotificationEnabled": _messageNotificationEnabled,
        "eventNotificationEnabled": _eventsNotificationsEnabled
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getInitialNotificationState();
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
      _matchResultNotificationEnabled = value;
      _messageNotificationEnabled = value;
      _eventsNotificationsEnabled = value;
      _updateNotificationSetting();
    });
  }

  void _toggleIndividualNotification(String notificationType, bool value) {
    setState(() {
      if (notificationType == 'matchResult') {
        _matchResultNotificationEnabled = value;
      } else if (notificationType == 'message') {
        _messageNotificationEnabled = value;
      } else if (notificationType == 'event') {
        _eventsNotificationsEnabled = value;
      }
      _updateNotificationSetting();
    });
  }

  Widget _buildNotificationSwitch(String title, bool value, String notificationType) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      activeTrackColor: Theme.of(context).colorScheme.primary,
      onChanged: (value) => _toggleIndividualNotification(notificationType, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Notifications'),
              value: _notificationsEnabled,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              onChanged: _toggleNotifications,
            ),
            if (_notificationsEnabled) ...[
              _buildNotificationSwitch('Match result notifications', _matchResultNotificationEnabled, 'matchResult'),
              _buildNotificationSwitch('Messaging notifications', _messageNotificationEnabled, 'message'),
              _buildNotificationSwitch('Event notifications', _eventsNotificationsEnabled, 'event'),
            ],
          ],
        ),
      ),
    );
  }
}
