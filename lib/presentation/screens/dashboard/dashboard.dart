import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/presentation/screens/dashboard/bond/bond_screen.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/events.dart';
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

String _prevUid = "";
StreamSubscription<RemoteMessage>? _subOnMsg;
StreamSubscription<RemoteMessage>? _subOnOpen;
StreamSubscription<User?>? _subAuth;
StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subMatch;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackground(RemoteMessage m) async {
  debugPrint('🔕 BG push: ${m.notification?.title}');
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIdx = 0;
  bool _hasMatch = false;
  bool _preferExplore = false;

  bool get _eligibleWeekday {
    final w = DateTime.now().weekday;
    return w >= DateTime.monday && w <= DateTime.friday;
  }

  bool get _canShowEvent => _hasMatch && _eligibleWeekday;

  bool get _showingEvent => _canShowEvent && !_preferExplore;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  @override
  void dispose() {
    _subOnMsg?.cancel();
    _subOnOpen?.cancel();
    _subAuth?.cancel();
    _subMatch?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['initialIndex'] is int) {
      final i = args['initialIndex'] as int;
      if (i >= 0 && i <= 3) setState(() => _currentIdx = i);
    }
  }

  Future<void> _initFCM() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true, badge: true, sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);

    _subOnMsg?.cancel();
    _subOnMsg = FirebaseMessaging.onMessage.listen(_showAlert);

    FirebaseMessaging.instance.getInitialMessage().then((m) {
      if (m != null) _handleTap(m);
    });

    _subOnOpen?.cancel();
    _subOnOpen = FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    _subAuth?.cancel();
    _subAuth = FirebaseAuth.instance.authStateChanges().listen((u) async {
      await _swapTopic(u);
      await _listenMatch(u);
    });
  }

  void _showAlert(RemoteMessage m) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: Text(m.notification?.title ?? 'Notification'),
        content: Text(m.notification?.body ?? ''),
        actions: [
          TextButton(
            onPressed: () { Navigator.of(c).pop(); _handleTap(m); },
            child: const Text('View')),
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Dismiss')),
        ],
      ),
    );
  }

  void _handleTap(RemoteMessage m) {
    final type = m.data['type'];
    if (type == NotificationType.MATCH_RESULT.value) {
      setState(() => _currentIdx = 1);
    } else if (type == NotificationType.EVENT.value) {
      setState(() {
        _currentIdx = 0;
        _preferExplore = false;
      });
    }
  }

  Future<void> _swapTopic(User? u) async {
    if (u != null && u.uid != _prevUid) {
      if (_prevUid.isNotEmpty) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(_prevUid);
      }
      await FirebaseMessaging.instance.subscribeToTopic(u.uid);
      _prevUid = u.uid;
    } else if (u == null && _prevUid.isNotEmpty) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(_prevUid);
      _prevUid = "";
    }
  }

  Future<void> _listenMatch(User? u) async {
    await _subMatch?.cancel();
    if (u == null) {
      if (_hasMatch) setState(() => _hasMatch = false);
      return;
    }
    _subMatch = FirebaseFirestore.instance
        .collection('users')
        .doc(u.uid)
        .snapshots()
        .listen((snap) {
      final has = (snap.data()?['match'] ?? '').toString().isNotEmpty;
      if (mounted && has != _hasMatch) {
        setState(() {
          _hasMatch = has;
          if (!_hasMatch) _preferExplore = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget exploreOrEvent =
        _showingEvent ? const EventRoomScreen() : const ExploreScreen();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('BBond',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w900,
            )),
        actions: [
          if (_canShowEvent)
            IconButton(
              icon: Icon(_showingEvent ? Icons.explore : Icons.groups),
              tooltip: _showingEvent ? 'Go to Explore' : 'Go to Event',
              onPressed: () => setState(() => _preferExplore = !_preferExplore),
            ),
        ],
      ),
      body: _currentIdx == 0
          ? exploreOrEvent
          : _currentIdx == 1
              ? const BondScreen()
              : _currentIdx == 2
                  ? const ProfileScreen()
                  : const SettingsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        currentIndex: _currentIdx,
        onTap: (i) => setState(() => _currentIdx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'My Bond'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}