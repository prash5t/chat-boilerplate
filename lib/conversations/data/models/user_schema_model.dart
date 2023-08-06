import 'dart:convert';

import 'package:chatbot/conversations/data/models/schema_bot_model.dart';

class UserSchemaModel {
  List<SchemaBotModel>? chatbots;
  UserSchemaModel({this.chatbots});
  static const String kKeyChatbots = 'chatbots';
  UserSchemaModel.fromJson(String chatBotSchema, String userId) {
    Map<String, dynamic> userSchemaInJson = jsonDecode(chatBotSchema)[userId];
    if (userSchemaInJson[kKeyChatbots] != null) {
      chatbots = <SchemaBotModel>[];
      userSchemaInJson[kKeyChatbots].forEach((v) {
        chatbots!.add(SchemaBotModel.fromJson(v));
      });
    }
  }
}
