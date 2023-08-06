import 'package:chatbot/conversations/data/models/persona_model.dart';

class BotModel {
  String? botId;
  String? createdAt;
  PersonaModel? persona;
  //fyi: messages field is to store if any follow up messages are availale for this user
  List<dynamic>? messages;

  BotModel({this.botId, this.createdAt, this.persona, this.messages});

  static const String kKeyId = 'id';
  static const String kKeyPersona = 'persona';
  static const String kKeyDescription = 'description';
  static const String kKeyType = 'type';
  static const String kKeyCreatedAt = 'createdAt';
  static const String kKeyMessages = 'messages';
  static const String kKeyIsAvailable = 'isAvailable';

  BotModel.fromJson(Map<String, dynamic> json) {
    botId = json[kKeyId];
    createdAt = json[kKeyCreatedAt];
    messages = json[kKeyMessages];
    persona = PersonaModel.fromJson(json[kKeyPersona]);
  }
}
