import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  SharedPreferences prefs = locator<SharedPreferences>();

  Future<void> clearAll() async {
    prefs.remove(SharedPrefsKeys.accessToken);

    // keep more items as per need
  }

  Future<String?> getAccessToken() async {
    return prefs.getString(SharedPrefsKeys.accessToken);
  }

  Future<void> setAccessToken(final String token) async {
    prefs.setString(SharedPrefsKeys.accessToken, token);
  }

  Future<bool> isDark() async {
    /// fyi: by default, setting light mode, so returning false if null, cause initially, its null :)
    return prefs.getBool(SharedPrefsKeys.isDarkMode) ?? false;
  }

  Future<void> switchTheme(bool isDark) async {
    /// fyi: if its dark, we change to light and vice versa
    prefs.setBool(SharedPrefsKeys.isDarkMode, !isDark);
  }
}
