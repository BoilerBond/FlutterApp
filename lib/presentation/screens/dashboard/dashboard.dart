import 'dart:async';

import 'package:datingapp/presentation/screens/dashboard/bond/bond_screen.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/explore_screen.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/profile_screen.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationType {
  MATCH_RESULT("MATCH_RESULT"),
  MESSAGING("MESSAGING"),
  EVENT("EVENT");

  final String value;
  const NotificationType(this.value);
}

String previousUserId = "";
StreamSubscription<RemoteMessage>? onMessageSubscription;
StreamSubscription<RemoteMessage>? onMessageOpenAppSubscription;
StreamSubscription<User?>? authSubscription;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.notification!.title}');
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    ExploreScreen(),
    BondScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  Future<void> init(BuildContext context) async {
    // Requesting permission for notifications
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted notifications permission: ${settings.authorizationStatus}');

    // Handling background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (onMessageSubscription != null) {
      await onMessageSubscription!.cancel();
      onMessageSubscription = null;
    }
    // Display dialog for displaying messages when user is on the app
    onMessageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            child: AlertDialog(
              title: Text(message.notification!.title!),
              content: Text(message.notification!.body!),
              actions: [
                TextButton(
                  onPressed: () {
                    if (message.data.containsKey('type') && message.data['type'] == NotificationType.MATCH_RESULT.value) {
                      Navigator.of(context).pop();
                      setState(() {
                        _currentIndex = 1;
                      });
                    }
                  },
                  child: const Text('View'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        },
      );
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    if (onMessageOpenAppSubscription != null) {
      await onMessageOpenAppSubscription!.cancel();
      onMessageOpenAppSubscription = null;
    }

    // Called when user opens the notification
    onMessageOpenAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(context, message);
    });

    if (authSubscription != null) {
      await authSubscription!.cancel();
      authSubscription = null;
    }
    authSubscription = FirebaseAuth.instance.authStateChanges().listen(subscribeToUserTopic);
  }

  // Subscribe to the topic reserved for the user (the user uid)
  Future<void> subscribeToUserTopic(User? user) async {
    if (user != null) {
      if (previousUserId != user.uid) {
        if (previousUserId.isNotEmpty) {
          await FirebaseMessaging.instance.unsubscribeFromTopic(previousUserId);
          print("unsubscribed to topic $previousUserId");
        }
        await FirebaseMessaging.instance.subscribeToTopic(user.uid);
        print("subscribed to topic ${user.uid}");
        previousUserId = user.uid;
      }
    } else if (previousUserId.isNotEmpty) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(previousUserId);
      print("unsubscribed to topic $previousUserId");
      previousUserId = "";
    }
  }

  // Handler for clicking the notification
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    if (message.data.containsKey('type') && message.data['type'] == NotificationType.MATCH_RESULT.value) {
      setState(() {
        _currentIndex = 1;
      });
    }
  }

  // Remove all listeners
  Future<void> disposeListeners() async {
    if (onMessageSubscription != null) {
      await onMessageSubscription!.cancel();
      onMessageSubscription = null;
    }
    if (onMessageOpenAppSubscription != null) {
      await onMessageOpenAppSubscription!.cancel();
      onMessageOpenAppSubscription = null;
    }
    if (authSubscription != null) {
      await authSubscription!.cancel();
      authSubscription = null;
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      init(context);
    }
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BBond', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900)),
        automaticallyImplyLeading: false,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Bond',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
