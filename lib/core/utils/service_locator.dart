import 'package:chatbot/conversations/data/repository/conversation_implementation.dart';
import 'package:chatbot/conversations/data/repository/conversation_repo.dart';
import 'package:chatbot/core/network/client/base_client.dart';
import 'package:chatbot/core/utils/analytics/analytics_keys.dart';
import 'package:chatbot/core/utils/schema_helper.dart';
import 'package:chatbot/menu/repo/menu_repo.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../menu/repo/menu_implementation.dart';
import '../network/client/base_client_implementation.dart';
import '../../login/data/implementation/auth_implementation.dart';
import '../../login/data/repository/auth_repo.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

final locator = GetIt.instance;

setUpLocator() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Mixpanel mixpanel = await Mixpanel.init(AnalyticsKeys.mixPanelToken,
      trackAutomaticEvents: true);
  mixpanel.setLoggingEnabled(true);
  locator.registerSingleton<Mixpanel>(mixpanel);
  // locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  locator.registerFactory<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  locator.registerSingleton<SharedPreferences>(prefs);
  locator.registerFactory(() => FirebaseAuth.instance);
  locator.registerFactory<BaseClient>(() => BaseClientImpl());
  locator.registerFactory<AuthRepo>(() => AuthImpl(locator()));
  locator.registerFactory<MenuRepo>(() => MenuImpl(locator()));
  locator.registerFactory<ConversationRepo>(() => ConversationImpl(locator()));
  locator.registerLazySingleton<FirebaseRemoteConfig>(
      () => FirebaseRemoteConfig.instance);
  locator.registerFactory(() => SchemaHelper());
  locator.registerSingleton(FlutterLocalNotificationsPlugin());
  locator.registerSingleton(FirebaseMessaging.instance);
  locator.registerSingleton(FirebaseAnalytics.instance);
  locator.registerSingleton(InternetConnectionChecker());
}
