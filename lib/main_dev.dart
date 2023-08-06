import 'package:chatbot/core/constants/network_constants.dart';
import 'package:chatbot/core/utils/analytics/analytics_keys.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/firebase/firebase_setup.dart';
import 'main_prod.dart';
import 'notifications/top_level_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup("BoilerplateDev").initializeFirebase();
  NetworkConstants.baseUrl = NetworkConstants.devBaseUrl;
  AnalyticsKeys.mixPanelToken = AnalyticsKeys.mixPanelDevToken;
  await setUpLocator();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
  await SentryFlutter.init(
    (options) {
      options.dsn = 'KEEP_YOUR_SENTRY_URL';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp(
      title: "Chatbot",
    )),
  );
}
