import 'package:datingapp/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String previousUserId = "";

// Handles background messages
Future<void> _backgroundNotificationHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Background message received: ${message.notification?.title}");
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

Future<void> setupTopicSubscription() async {
  await subscribeToUserTopic(FirebaseAuth.instance.currentUser);
  FirebaseAuth.instance.authStateChanges().listen(subscribeToUserTopic);
}

// Request permission on the device
Future<void> requestNotifyPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

void enableBackgroundNotificationListener() {
  FirebaseMessaging.onBackgroundMessage(_backgroundNotificationHandler);
}

void enableForegroundNotificationListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground message received: ${message.notification?.title}");
  });
}

Future<void> enableNotificationListeners() async {
  await requestNotifyPermission();
  await setupTopicSubscription();
  enableForegroundNotificationListener();
  enableBackgroundNotificationListener();
}
