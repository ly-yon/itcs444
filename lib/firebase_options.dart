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
    apiKey: "AIzaSyDaYezar8WW4kVYDut3kNTIiM-y_CNJhmk",
  authDomain: "itcs444-92e3f.firebaseapp.com",
  projectId: "itcs444-92e3f",
  storageBucket: "itcs444-92e3f.firebasestorage.app",
  messagingSenderId: "293487894537",
  appId: "1:293487894537:web:cb807b4e0a669e098bd8d8"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgTdijoAFcRQrORptHqdk6hzSAPu1OzgA',
    appId: '1:293487894537:android:9f0ce97455876a008bd8d8',
    messagingSenderId: '293487894537',
    projectId: 'itcs444-92e3f',
    storageBucket: 'itcs444-92e3f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB802FAKJhfR67Zay812oEkpsSKuXF_C_8',
    appId: '1:293487894537:ios:6989bc89213d4ea78bd8d8',
    messagingSenderId: '293487894537',
    projectId: 'itcs444-92e3f',
    storageBucket: 'itcs444-92e3f.firebasestorage.app',
    iosBundleId: 'com.example.projectTest2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB802FAKJhfR67Zay812oEkpsSKuXF_C_8',
    appId: '1:293487894537:ios:6989bc89213d4ea78bd8d8',
    messagingSenderId: '293487894537',
    projectId: 'itcs444-92e3f',
    storageBucket: 'itcs444-92e3f.firebasestorage.app',
    iosBundleId: 'com.example.projectTest2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDaYezar8WW4kVYDut3kNTIiM-y_CNJhmk',
    appId: '1:293487894537:web:1a12a4fb4f57e44e8bd8d8',
    messagingSenderId: '293487894537',
    projectId: 'itcs444-92e3f',
    authDomain: 'itcs444-92e3f.firebaseapp.com',
    storageBucket: 'itcs444-92e3f.firebasestorage.app',
  );

}