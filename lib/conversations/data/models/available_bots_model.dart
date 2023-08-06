import 'package:chatbot/conversations/data/models/bot_model.dart';

class AvailableBotsModel {
  List<BotModel>? chatbots;
  AvailableBotsModel({this.chatbots});
  static const String kKeyChatbots = 'chatbots';
  AvailableBotsModel.fromJson(Map<String, dynamic> json) {
    if (json[kKeyChatbots] != null) {
      chatbots = <BotModel>[];
      json[kKeyChatbots].forEach((v) {
        chatbots!.add(BotModel.fromJson(v));
      });
    }
  }
}
