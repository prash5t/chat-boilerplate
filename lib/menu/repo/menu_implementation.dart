import 'package:chatbot/core/constants/network_constants.dart';
import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:chatbot/core/network/client/base_client.dart';
import 'package:chatbot/core/network/failure/failure.dart';
import 'package:chatbot/core/network/functions/get_parsed_data.dart';
import 'package:chatbot/core/utils/analytics/analytics_keys.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/menu/repo/menu_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuImpl implements MenuRepo {
  final BaseClient _client;

  MenuImpl(this._client);

  @override
  Future<Either<void, Failure>> deleteUserAccount() async {
    // delete user's mixpanel events
    String? userId =
        await locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    Map<String, dynamic> data = {
      "\$token": AnalyticsKeys.mixPanelToken,
      "\$distinct_id": userId,
      "\$delete": "null",
      "\$ignore_alias": false,
    };
    Response? response;
    await Dio().post(NetworkConstants.mixpanelAccDeleteEndPoint, data: data);

    // delete acc from backend
    response = await _client.deleteRequest(
        baseUrl: NetworkConstants.baseUrl, path: "users/me");

    return getParsedData(response, Null);
  }
}
