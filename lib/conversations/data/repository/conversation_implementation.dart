import 'package:chatbot/chat/models/schema_message_model.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/constants/network_constants.dart';
import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:chatbot/conversations/data/models/created_chatbot_model.dart';
import 'package:chatbot/conversations/data/models/user_profile_model.dart';
import 'package:chatbot/conversations/data/repository/conversation_repo.dart';
import 'package:chatbot/core/network/client/base_client.dart';
import 'package:chatbot/core/network/failure/failure.dart';
import 'package:chatbot/core/network/functions/get_parsed_data.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationImpl implements ConversationRepo {
  final BaseClient _client;
  ConversationImpl(this._client);

  @override
  Future<Either<UserProfileModel, Failure>> getProfileAndBots() async {
    final response = await _client.getRequest(
        baseUrl: NetworkConstants.baseUrl, path: "users/me");
    return getParsedData(response, UserProfileModel.fromJson);
  }

  @override
  Future<Either<SchemaBotModel, Failure>> searchNewBot() async {
    String timeZone = DateTime.now().timeZoneName;
    String? userId =
        await locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    final response = await _client.getRequest(
        optionalHeaders: {NetworkConstants.kKeyForTimeZone: 'UTC +$timeZone'},
        baseUrl: NetworkConstants.baseUrl,
        path: "chat/$userId/random-chatbot");
    return getParsedData(response, SchemaBotModel.fromJson);
  }

  @override
  Future<Either<CreatedBotModel, Failure>> createNewConversation(
      {String? choosedBotId}) async {
    String? userId =
        await locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    final response = await _client.postRequest(
        baseUrl: NetworkConstants.baseUrl,
        path: "chat/$userId/chatbots/$choosedBotId");

    return getParsedData(response, CreatedBotModel.fromJson);
  }

  @override
  Future<Either<void, Failure>> deleteThisBot(String botId) async {
    String? userId =
        locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    final response = await _client.deleteRequest(
        baseUrl: NetworkConstants.baseUrl,
        path: "chat/$userId/chatbots/$botId");
    return getParsedData(response, Null);
  }

  @override
  Future<Either<SchemaMessageModel, Failure>> getNewMessage(
      List<dynamic> ongoingConversation, String botId) async {
    String? userId =
        locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    final response = await _client.postRequest(
        baseUrl: NetworkConstants.baseUrl,
        path: "chat/$userId/chatbots/$botId/v2/prompt",
        data: {"messages": ongoingConversation});

    return getParsedData(response, SchemaMessageModel.fromJson);
  }

  @override
  Future<Either<void, Failure>> notifyFollowUpsAreSynced(
      String chatBotId) async {
    String? userId =
        locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    String pathToNotifyMsgSync = "chat/$userId/chatbots/$chatBotId/synced";
    final response = await _client.getRequest(
        baseUrl: NetworkConstants.baseUrl, path: pathToNotifyMsgSync);
    return getParsedData(response, Null);
  }
}
