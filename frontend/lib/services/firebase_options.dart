// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCkraMTZXSSu-dvUkRJttJXett3UC-4Nhc',
    appId: '1:295774991714:web:9af5aa36be1b446763e83b',
    messagingSenderId: '295774991714',
    projectId: 'studygroup-8d056',
    authDomain: 'studygroup-8d056.firebaseapp.com',
    storageBucket: 'studygroup-8d056.appspot.com',
    measurementId: 'G-YSJC32JWDY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFhVrSilrga3q7Q7rk_tddWcrXXo4ogIM',
    appId: '1:295774991714:android:fd2012676c1ebe0663e83b',
    messagingSenderId: '295774991714',
    projectId: 'studygroup-8d056',
    storageBucket: 'studygroup-8d056.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgoBBGI8XHdaOlzplXfMJ8kPJjkvxr9WY',
    appId: '1:295774991714:ios:4e1b76ea3063d78863e83b',
    messagingSenderId: '295774991714',
    projectId: 'studygroup-8d056',
    storageBucket: 'studygroup-8d056.appspot.com',
    iosBundleId: 'com.ssu.groupstudy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgoBBGI8XHdaOlzplXfMJ8kPJjkvxr9WY',
    appId: '1:295774991714:ios:61cc680d19093f3663e83b',
    messagingSenderId: '295774991714',
    projectId: 'studygroup-8d056',
    storageBucket: 'studygroup-8d056.appspot.com',
    iosBundleId: 'com.example.groupstudy.RunnerTests',
  );
}
