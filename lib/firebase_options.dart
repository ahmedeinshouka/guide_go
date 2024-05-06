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
    apiKey: 'AIzaSyCaDAtBL92OlvczGsgJRLejciDocZHAurA',
    appId: '1:427660763075:web:f8172a2356e1eb3a04a776',
    messagingSenderId: '427660763075',
    projectId: 'guide-go-81578',
    authDomain: 'guide-go-81578.firebaseapp.com',
    storageBucket: 'guide-go-81578.appspot.com',
    measurementId: 'G-EQT0ZX7D6R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB97DtFGpqyKaMsG2YwyVjmjtXfkknn6FM',
    appId: '1:427660763075:android:5fc4fa276695272e04a776',
    messagingSenderId: '427660763075',
    projectId: 'guide-go-81578',
    storageBucket: 'guide-go-81578.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuLQp3Sw8V76vKwzY8DKUY1UiNOgSFHpw',
    appId: '1:427660763075:ios:f9cf8be7a9e2eaee04a776',
    messagingSenderId: '427660763075',
    projectId: 'guide-go-81578',
    storageBucket: 'guide-go-81578.appspot.com',
    iosBundleId: 'com.example.guideGo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuLQp3Sw8V76vKwzY8DKUY1UiNOgSFHpw',
    appId: '1:427660763075:ios:f9cf8be7a9e2eaee04a776',
    messagingSenderId: '427660763075',
    projectId: 'guide-go-81578',
    storageBucket: 'guide-go-81578.appspot.com',
    iosBundleId: 'com.example.guideGo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCaDAtBL92OlvczGsgJRLejciDocZHAurA',
    appId: '1:427660763075:web:d1e2ac1d5a7f8bdf04a776',
    messagingSenderId: '427660763075',
    projectId: 'guide-go-81578',
    authDomain: 'guide-go-81578.firebaseapp.com',
    storageBucket: 'guide-go-81578.appspot.com',
    measurementId: 'G-P4ZV3DP1SV',
  );
}
