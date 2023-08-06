class NetworkConstants {
  /// FYI: baseUrl is updated on build as per the env (dev/prod)
  /// so, initializing it as empty below.
  static String baseUrl = "";
  static const String prodBaseUrl = "BASE_URL_OF_PROD";
  static const String devBaseUrl = "BASE_URL_OF_DEV";
  static const String urlForIPInfo = "http://ip-api.com/json";
  static const Map<String, String> headerWithoutToken = {
    'Content-Type': 'application/json'
  };

  static const String kKeyForTimeZone = "timezone-offset";

  static const String termsUrl = "URL_OF_TERMS_AND_CONDITIONS_OF_APP";
  static const String privacyUrl = "URL_OF_PRIVACY_POLICY_OF_APP";

  // mixpanel acc delete endpoint
  static const String mixpanelAccDeleteEndPoint =
      "https://api.mixpanel.com/engage#profile-delete";

  static const String kKeyTokenExpired = "TOKEN_EXPIRED";
  static const String kKeyMessage = "message";
}
