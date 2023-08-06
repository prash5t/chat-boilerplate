import 'dart:convert';
import 'package:chatbot/core/constants/app_constants.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/routes/nav_helper.dart';
import 'package:chatbot/core/utils/logger/debug_log.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
  debugLog("notificationTapBackground: ${notificationResponse.toString()}");
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) {
  Map<String, dynamic> jsonPayload =
      jsonDecode(notificationResponse.payload ?? "{}");
  String? botId = jsonPayload[SchemaBotModel.kKeyChatBotId];
  NavHelper.navigateToChat(botId: botId);
}

void handleFCMNotificationTapFromBackground() {
  Stream<RemoteMessage> _stream = FirebaseMessaging.onMessageOpenedApp;
  _stream.listen((RemoteMessage message) async {
    handleFCMNotificationTap(message: message);
  });
}

void handleAppLaunchedFromFCMNotification() async {
  final RemoteMessage? message =
      await locator<FirebaseMessaging>().getInitialMessage();
  handleFCMNotificationTap(message: message, appLaunchedFromNotification: true);
}

void handleFCMNotificationTap(
    {RemoteMessage? message, bool appLaunchedFromNotification = false}) {
  if (message != null) {
    if (message.data[AppConstants.kKeyTypeInNotification] ==
        AppConstants.kKeyChatInNotificationData) {
      String? botId = message.data[AppConstants.kKeyBotIdInNotification];
      debugPrint("check: botId $botId");
      NavHelper.navigateToChat(
          botId: botId,
          appLaunchedFromNotification: appLaunchedFromNotification);
    }
  }
}

/// fyi: right now, we are syncing follow up msgs on background
/// using AppLifecycleState.resumed, so below function is dummy for now
Future<void> handleBackgroundNotification(RemoteMessage message) async {
  debugPrint('Got a message whilst in the background!');
  debugPrint('Message : ${message.toMap().toString()}');

  if (message.notification != null) {
    debugPrint(
        'Message also contained a notification: ${message.notification!.title}');
  }
}
