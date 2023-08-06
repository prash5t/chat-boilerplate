import 'dart:convert';
import 'package:chatbot/core/constants/network_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<String> getISOCode() async {
  try {
    http.Response response =
        await http.get(Uri.parse(NetworkConstants.urlForIPInfo));
    Map<String, dynamic> jsonResp = jsonDecode(response.body);
    return jsonResp['countryCode'];
  } catch (e) {
    debugPrint("Error fetching iso code from network: $e");
    // in case of network error or ip info provider (third party) makes change in response format,
    // need to select a default country code, thats why returning empty string
    // to achive smooth ui flow in case of exceptions
    return "";
  }
}
