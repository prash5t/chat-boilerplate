import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

import 'firebase_options.dart';

class FirebaseSetup {
  final String name;
  //Constructor for Firebase Setup
  FirebaseSetup(this.name);

  //Initilalizing firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      name: Platform.isAndroid ? name : null,
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    initCrashylitcs();
    initializeFirebaseAnalytics();
  }

  void initializeFirebaseAnalytics() {}

  void initCrashylitcs() {}
}
