import 'package:datingapp/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Handles background messages
Future<void> _backgroundNotificationHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  print("Background message received: ${message.notification?.title}");
}

// Subscribe to the topic reserved for the user (the user uid)
Future<void> subscribeToUserTopic() async {
  if (FirebaseAuth.instance.currentUser != null) {
    await FirebaseMessaging.instance.subscribeToTopic(FirebaseAuth.instance.currentUser!.uid);
    print("subscribed to topic ${FirebaseAuth.instance.currentUser!.uid}");
  }
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
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
    }
  );
}

Future<void> enableNotificationListeners() async {
  await requestNotifyPermission();
  await subscribeToUserTopic();
  enableForegroundNotificationListener();
  enableBackgroundNotificationListener();
}
