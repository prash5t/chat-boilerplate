import 'package:chatbot/core/utils/service_locator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

Future<void> logEventInAnalytics(String eventName,
    {Map<String, dynamic>? parameters}) async {
  // log to firebase analytics
  locator<FirebaseAnalytics>()
      .logEvent(name: eventName, parameters: parameters);

  // log to mixpanel
  locator<Mixpanel>().track(eventName, properties: parameters);

  debugPrint("Log event: $eventName");
}

Future<void> setUserIdInAnalytics(String userId) async {
  // set user id in firebase analytics
  locator<FirebaseAnalytics>().setUserId(id: userId);

  // set user id in mixpanel
  locator<Mixpanel>().identify(userId);

  debugPrint("Set user id to analytics: $userId");
}

Future<void> setUserPropertiesInAnalytics(
    String propertyKey, String propertyValue) async {
  // set user properties in firebase analytics
  locator<FirebaseAnalytics>()
      .setUserProperty(name: propertyKey, value: propertyValue);

  // set user properties in mixpanel
  locator<Mixpanel>().getPeople().set("\$$propertyKey", propertyValue);
  debugPrint("Set user properties, $propertyKey: $propertyValue");
}
