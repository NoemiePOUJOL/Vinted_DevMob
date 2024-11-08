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
    apiKey: 'AIzaSyBXPVokYbANQB80EkV50pE_zIpkTOuVlbU',
    appId: '1:1093059810955:web:10a0658fd871b57439668e',
    messagingSenderId: '1093059810955',
    projectId: 'flutterproject-b522d',
    authDomain: 'flutterproject-b522d.firebaseapp.com',
    storageBucket: 'flutterproject-b522d.appspot.com',
    measurementId: 'G-J8CDS0HZ8N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFO3OUGwk5fxIZ_BrTaUwnTykRBjMM0L0',
    appId: '1:1093059810955:android:67689900175e16af39668e',
    messagingSenderId: '1093059810955',
    projectId: 'flutterproject-b522d',
    storageBucket: 'flutterproject-b522d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBx4CF6mnJic4g9iqjlNQAjVnwy2vWrMnw',
    appId: '1:1093059810955:ios:5b68dd1b1b465cab39668e',
    messagingSenderId: '1093059810955',
    projectId: 'flutterproject-b522d',
    storageBucket: 'flutterproject-b522d.appspot.com',
    iosBundleId: 'com.example.flutterProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBx4CF6mnJic4g9iqjlNQAjVnwy2vWrMnw',
    appId: '1:1093059810955:ios:5b68dd1b1b465cab39668e',
    messagingSenderId: '1093059810955',
    projectId: 'flutterproject-b522d',
    storageBucket: 'flutterproject-b522d.appspot.com',
    iosBundleId: 'com.example.flutterProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXPVokYbANQB80EkV50pE_zIpkTOuVlbU',
    appId: '1:1093059810955:web:bf28a0d94c1ac2fc39668e',
    messagingSenderId: '1093059810955',
    projectId: 'flutterproject-b522d',
    authDomain: 'flutterproject-b522d.firebaseapp.com',
    storageBucket: 'flutterproject-b522d.appspot.com',
    measurementId: 'G-KSX02YEN6F',
  );
}
