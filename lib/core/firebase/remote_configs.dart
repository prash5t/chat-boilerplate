import 'package:chatbot/core/utils/service_locator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigs {
  static Future<void> fetchAndActivateRemoteConfig() async {
    FirebaseRemoteConfig rc = locator<FirebaseRemoteConfig>();
    await rc.fetch();
    await rc.activate();
    bool? featureEnabled = rc.getBool('your_feature_enabled');
    String? welcomeMessage = rc.getString('welcome_message');
    debugPrint("check: $featureEnabled $welcomeMessage");
  }
}
