import 'dart:convert';
import 'package:chatbot/chat/presentation/chat_global_vars.dart';
import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:chatbot/conversations/data/models/bot_model.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/data/models/user_profile_model.dart';
import 'package:chatbot/conversations/data/models/user_schema_model.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchemaHelper {
  Future<List<dynamic>> getConversationWithBot(final String botId) async {
    String? userId =
        await locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    String? chatBotSchema = await locator<FlutterSecureStorage>()
        .read(key: SharedPrefsKeys.chatbotSchemaKey);
    if (chatBotSchema != null) {
      UserSchemaModel userSchema =
          UserSchemaModel.fromJson(chatBotSchema, userId!);
      for (SchemaBotModel bot in userSchema.chatbots ?? []) {
        if (bot.chatbotId == botId) {
          return bot.conversations ?? [];
        }
      }
      // when provided botId do not exist in user schema
      return [];
    }
    // when chatbotSchema is null
    return [];
  }

  Future<void> markConversationAsRead(
      {required String botId, bool isRead = true}) async {
    String? userId =
        await locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    String? chatBotSchema = await locator<FlutterSecureStorage>()
        .read(key: SharedPrefsKeys.chatbotSchemaKey);
    Map<String, dynamic> jsonSchema = jsonDecode(chatBotSchema!);
    List<dynamic> chatbots = jsonSchema[userId][UserSchemaModel.kKeyChatbots];
    for (Map<String, dynamic> bot in chatbots) {
      if (bot[SchemaBotModel.kKeyChatBotId] == botId) {
        bot[SchemaBotModel.kKeyIsRead] = isRead;
      }
    }
    jsonSchema[userId][UserSchemaModel.kKeyChatbots] = chatbots;
    await locator<FlutterSecureStorage>().write(
        key: SharedPrefsKeys.chatbotSchemaKey, value: jsonEncode(jsonSchema));
  }

  Future<void> updatePersonaOfThisBot(BotModel botProfileToUpdate) async {
    String? userId =
        await locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    String? chatBotSchema = await locator<FlutterSecureStorage>()
        .read(key: SharedPrefsKeys.chatbotSchemaKey);
    if (chatBotSchema != null) {
      Map<String, dynamic> jsonSchema = jsonDecode(chatBotSchema);
      List<dynamic> chatbots = jsonSchema[userId][UserSchemaModel.kKeyChatbots];
      for (Map<String, dynamic> bot in chatbots) {
        if (bot[SchemaBotModel.kKeyChatBotId] == botProfileToUpdate.botId) {
          bot[SchemaBotModel.kKeyPersona] =
              botProfileToUpdate.persona!.toJson();
        }
      }
      jsonSchema[userId][UserSchemaModel.kKeyChatbots] = chatbots;
      await locator<FlutterSecureStorage>().write(
          key: SharedPrefsKeys.chatbotSchemaKey, value: jsonEncode(jsonSchema));
    }
  }

  /// fyi: return true if schema not null and msg is updated
  /// return false if schema is null
  Future<bool> updateMessagesWithThisBot(
      String botId,
      List<dynamic> updatedConversationHistory,
      String lastConversation,
      DateTime lastConversationTime) async {
    String? userId =
        await locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    String? chatBotSchema = await locator<FlutterSecureStorage>()
        .read(key: SharedPrefsKeys.chatbotSchemaKey);
    if (chatBotSchema == null) {
      return false;
    } else {
      Map<String, dynamic> jsonSchema = jsonDecode(chatBotSchema);
      List<dynamic> chatbots = jsonSchema[userId][UserSchemaModel.kKeyChatbots];
      bool isRead = isChatScreenOpen[botId] ?? false;
      for (Map<String, dynamic> bot in chatbots) {
        if (bot[SchemaBotModel.kKeyChatBotId] == botId) {
          bot[SchemaBotModel.kKeyConversations] = updatedConversationHistory;
          bot[SchemaBotModel.kKeyLastConversation] = lastConversation;
          bot[SchemaBotModel.kKeyLastUpdatedMessageTS] =
              lastConversationTime.toString();
          bot[SchemaBotModel.kKeyIsRead] = isRead;
        }
      }
      jsonSchema[userId][UserSchemaModel.kKeyChatbots] = chatbots;
      await locator<FlutterSecureStorage>().write(
          key: SharedPrefsKeys.chatbotSchemaKey, value: jsonEncode(jsonSchema));
      return true;
    }
  }

  Future<void> addNewConversation(SchemaBotModel newChatBot) async {
    String? userId =
        await locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    String? chatBotSchema = await locator<FlutterSecureStorage>()
        .read(key: SharedPrefsKeys.chatbotSchemaKey);
    bool schemaIsNull = chatBotSchema == null;
    Map<String, dynamic> jsonSchema =
        schemaIsNull ? {} : jsonDecode(chatBotSchema);
    List<dynamic> chatbots = schemaIsNull
        ? []
        : jsonSchema[userId]?[UserSchemaModel.kKeyChatbots] ?? [];
    chatbots.insert(0, newChatBot.toJson());
    jsonSchema[userId!] = {
      UserSchemaModel.kKeyChatbots: chatbots,
    };
    await locator<FlutterSecureStorage>().write(
        key: SharedPrefsKeys.chatbotSchemaKey, value: jsonEncode(jsonSchema));
  }

  Future<void> deleteConversation(String botIdToDelete) async {
    String? userId =
        locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    String? chatBotSchema = await locator<FlutterSecureStorage>()
        .read(key: SharedPrefsKeys.chatbotSchemaKey);

    if (chatBotSchema != null) {
      Map<String, dynamic> jsonSchema = jsonDecode(chatBotSchema);
      List<dynamic> chatbots = jsonSchema[userId][UserSchemaModel.kKeyChatbots];
      List<dynamic> updatedChatBots = [];

      for (Map<String, dynamic> bot in chatbots) {
        if (bot[SchemaBotModel.kKeyChatBotId] != botIdToDelete) {
          updatedChatBots.add(bot);
        }
      }
      jsonSchema[userId][UserSchemaModel.kKeyChatbots] = updatedChatBots;

      locator<FlutterSecureStorage>().write(
          key: SharedPrefsKeys.chatbotSchemaKey, value: jsonEncode(jsonSchema));
    }
  }

// this method returns all the available bots or
// if botId is provided, data of only that bot is returned in the list
  Future<List<SchemaBotModel>> getAvailableBots({String? botId}) async {
    String? userId =
        locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    List<SchemaBotModel> availableBots = [];
    String? chatbotSchema = await locator<FlutterSecureStorage>()
        .read(key: SharedPrefsKeys.chatbotSchemaKey);

    if (chatbotSchema == null) {
      debugPrint("No schema found in this key");
      return availableBots;
    } else {
      Map<String, dynamic>? jsonSchema = jsonDecode(chatbotSchema)[userId];

      if (jsonSchema == null) {
        return availableBots;
      }

      List<dynamic> chatbots = jsonSchema[UserSchemaModel.kKeyChatbots];

      if (chatbots.isEmpty) {
        debugPrint("chatbots field in schema is empty");
        return availableBots;
      }
      // if available, deserialize it to schema bot model and return in list
      for (Map<String, dynamic> eachBot in chatbots) {
        SchemaBotModel bot = SchemaBotModel.fromJson(eachBot);
        // when bot id is provided, return only that bots data
        if (botId != null && bot.chatbotId == botId) {
          return [bot];
        }
        availableBots.add(bot);
      }

      /// FYI
      // followup messages are coming for different users in the same device
      // if userA is logged in and followup for userB comes and user taps on it
      // we dont navigate user to chat screen
      // so if follow up msg was for this user, above for loop would return its value
      // if it didnot and reached upto this line,
      // this means bot id from that followup notification do not exist in this users list
      // so we are returning empty list below
      return botId != null ? [] : availableBots;
    }
  }

  //  to be used when user's bots are available while fetching from network
  updateChatBots(UserProfileModel userProfile) async {
    Map<String, dynamic> updatedSchema = {};

    // Update chatbots list
    if (userProfile.availableBots != null) {
      List<Map<String, dynamic>> chatbots = [];
      for (BotModel bot in userProfile.availableBots!.chatbots!) {
        Map<String, dynamic> chatbotData = {
          SchemaBotModel.kKeyChatBotId: bot.botId,
          SchemaBotModel.kKeyPersona: bot.persona?.toJson(),
          // messages (below three fields) to be added in this array from chatting screen
          SchemaBotModel.kKeyConversations: [],
          SchemaBotModel.kKeyLastUpdatedMessageTS: '',
          SchemaBotModel.kKeyLastConversation: '',
          SchemaBotModel.kKeyIsRead: true
        };
        chatbots.add(chatbotData);
      }
      updatedSchema[userProfile.userId!] = {
        UserSchemaModel.kKeyChatbots: chatbots,
      };
    }

    String updatedSchemaJson = jsonEncode(updatedSchema);

    // saving updatedSchema to secure storage
    await locator<FlutterSecureStorage>()
        .write(key: SharedPrefsKeys.chatbotSchemaKey, value: updatedSchemaJson);
  }
}
