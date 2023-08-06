import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/shared_prefs_constants.dart';
import '../../utils/service_locator.dart';

Map<String, String> getHeader({
  bool requiresAuthorization = true,
}) {
  String? token =
      locator<SharedPreferences>().getString(SharedPrefsKeys.accessToken);
  debugPrint("at: $token");
  return {
    "Content-Type": "application/json",
    "Bypass-Tunnel-Reminder": "for_local_endpoint",
    if (token != null && requiresAuthorization)
      "Authorization": "Bearer $token",
  };
}
