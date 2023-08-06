import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/notifications/update_persona_and_messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<dynamic> requestFCMPermission() async {
  FirebaseMessaging fm = locator<FirebaseMessaging>();
  NotificationSettings settings = await fm.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // uncomment below line if there is need to display fcm notif when app is in foreground
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  debugPrint("FCM's user granted permission: ${settings.authorizationStatus}");
  String? fcmToken = "";
  try {
    fcmToken = await locator<FirebaseMessaging>().getToken();
  } catch (e) {}

  debugPrint("fcmToken: $fcmToken");
}

Future<dynamic> handleForegroundNotification(BuildContext context) async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');

    debugPrint('Notification Remote:${message.toMap().toString()}');
    // when remote msg is received when app on foreground
    // fetch follow up msgs from network
    // first check if remote msg belongs to follow up msgs or not

    if (message.notification != null) {
      // when remote msg belong to follow up
      updatePersonaAndMessages(context);
    }
  }, onError: (e) {
    debugPrint("onMessage error: $e");
  });
}
