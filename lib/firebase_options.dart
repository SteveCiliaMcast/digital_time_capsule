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
    apiKey: 'AIzaSyCdky9kw7icZdPdFH4NCxN18ofPGtthzrQ',
    appId: '1:824653771650:web:734d3c63db572ffc79d59b',
    messagingSenderId: '824653771650',
    projectId: 'digital-time-capsule-b7161',
    authDomain: 'digital-time-capsule-b7161.firebaseapp.com',
    storageBucket: 'digital-time-capsule-b7161.firebasestorage.app',
    measurementId: 'G-4LB0P83Q06',
    databaseURL:
        'https://digital-time-capsule-b7161-default-rtdb.europe-west1.firebasedatabase.app/',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWYLC7hPINVVSlSmWXrJIAS1qUMkNNvq4',
    appId: '1:824653771650:android:e6a4e0e25ecdb87c79d59b',
    messagingSenderId: '824653771650',
    projectId: 'digital-time-capsule-b7161',
    storageBucket: 'digital-time-capsule-b7161.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5syqJDmHgumRTqcZ3riMo5SljM927WVg',
    appId: '1:824653771650:ios:6d350bdd1d96e26a79d59b',
    messagingSenderId: '824653771650',
    projectId: 'digital-time-capsule-b7161',
    storageBucket: 'digital-time-capsule-b7161.firebasestorage.app',
    iosBundleId: 'com.example.digitalTimeCapsule',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5syqJDmHgumRTqcZ3riMo5SljM927WVg',
    appId: '1:824653771650:ios:6d350bdd1d96e26a79d59b',
    messagingSenderId: '824653771650',
    projectId: 'digital-time-capsule-b7161',
    storageBucket: 'digital-time-capsule-b7161.firebasestorage.app',
    iosBundleId: 'com.example.digitalTimeCapsule',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCdky9kw7icZdPdFH4NCxN18ofPGtthzrQ',
    appId: '1:824653771650:web:afd4f19dddfabd2c79d59b',
    messagingSenderId: '824653771650',
    projectId: 'digital-time-capsule-b7161',
    authDomain: 'digital-time-capsule-b7161.firebaseapp.com',
    storageBucket: 'digital-time-capsule-b7161.firebasestorage.app',
    measurementId: 'G-6LFQPR4E38',
  );
}
