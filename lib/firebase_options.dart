// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD4yIiQ30J2FnfdgAHPi5irt33WsljaaSA',
    appId: '1:434594544336:web:b5ae1da3c72d5c9c0bfcd5',
    messagingSenderId: '434594544336',
    projectId: 'purduedatingapp',
    authDomain: 'purduedatingapp.firebaseapp.com',
    databaseURL: 'https://purduedatingapp-default-rtdb.firebaseio.com',
    storageBucket: 'purduedatingapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAP71oMhXhvIPqpO5wD4-5UAWtbkaXA0s0',
    appId: '1:434594544336:android:bdbc8ad3b5dee5820bfcd5',
    messagingSenderId: '434594544336',
    projectId: 'purduedatingapp',
    databaseURL: 'https://purduedatingapp-default-rtdb.firebaseio.com',
    storageBucket: 'purduedatingapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBig_ExPncoLRVz9owC7KQf-JEU1X98npw',
    appId: '1:434594544336:ios:39eb89bb80c750b60bfcd5',
    messagingSenderId: '434594544336',
    projectId: 'purduedatingapp',
    databaseURL: 'https://purduedatingapp-default-rtdb.firebaseio.com',
    storageBucket: 'purduedatingapp.firebasestorage.app',
    iosClientId: '434594544336-fj4ejrdcass7aipb66h2v3tndsg8h5ku.apps.googleusercontent.com',
    iosBundleId: 'com.example.datingapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBig_ExPncoLRVz9owC7KQf-JEU1X98npw',
    appId: '1:434594544336:ios:39eb89bb80c750b60bfcd5',
    messagingSenderId: '434594544336',
    projectId: 'purduedatingapp',
    databaseURL: 'https://purduedatingapp-default-rtdb.firebaseio.com',
    storageBucket: 'purduedatingapp.firebasestorage.app',
    iosClientId: '434594544336-fj4ejrdcass7aipb66h2v3tndsg8h5ku.apps.googleusercontent.com',
    iosBundleId: 'com.example.datingapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD4yIiQ30J2FnfdgAHPi5irt33WsljaaSA',
    appId: '1:434594544336:web:a886b14b4ce02e390bfcd5',
    messagingSenderId: '434594544336',
    projectId: 'purduedatingapp',
    authDomain: 'purduedatingapp.firebaseapp.com',
    databaseURL: 'https://purduedatingapp-default-rtdb.firebaseio.com',
    storageBucket: 'purduedatingapp.firebasestorage.app',
  );

}