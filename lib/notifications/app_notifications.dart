import 'dart:convert';
import 'package:chatbot/core/constants/app_constants.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/routes/nav_helper.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/notifications/top_level_functions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotifications {
  static const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    AppConstants.chatChannelId,
    AppConstants.chatChannelName,
    channelDescription: AppConstants.chatChannelDesc,
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
  );

  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    AndroidInitializationSettings androidInitialize =
        const AndroidInitializationSettings('drawable/splash');

    DarwinInitializationSettings iOSInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    /// fyi: when app is launched from local notification and payload have bot id
    /// we need to navigate to chat screen of that bot
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp &&
        notificationAppLaunchDetails.notificationResponse != null) {
      Map<String, dynamic> jsonPayload = jsonDecode(
          notificationAppLaunchDetails.notificationResponse?.payload ?? "{}");
      String? botId = jsonPayload[SchemaBotModel.kKeyChatBotId];
      if (botId != null) {
        NavHelper.navigateToChat(
            botId: botId, appLaunchedFromNotification: true);
      }
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // handle fcm notification opening app from background and from terminated state
    handleFCMNotificationTapFromBackground();
    handleAppLaunchedFromFCMNotification();
  }

  static Future showNotification(
      {int id = 0,
      required String title,
      required String body,
      dynamic payload}) async {
    NotificationDetails notificationDetails = const NotificationDetails(
        android: AppNotifications.androidNotificationDetails,
        iOS: DarwinNotificationDetails());

    await locator<FlutterLocalNotificationsPlugin>()
        .show(id, title, body, notificationDetails, payload: payload);
  }
}
