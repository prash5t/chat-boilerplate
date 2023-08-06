import 'package:chatbot/conversations/data/models/persona_model.dart';

class CreatedBotModel {
  PersonaModel? persona;
  String? personaId;
  String? createdAt;
  String? id;
  List<dynamic>? conversations;
  CreatedBotModel(
      {this.persona,
      this.personaId,
      this.createdAt,
      this.id,
      this.conversations});

  static const String kKeyPersona = "persona";
  static const String kKeyPersonaId = "personaId";
  static const String kKeyCreatedAt = "createdAt";
  static const String kKeyId = "id";
  static const String kKeyConversations = "messages";

  CreatedBotModel.fromJson(Map<String, dynamic> json) {
    persona = PersonaModel.fromJson(json[kKeyPersona]);
    personaId = json[kKeyPersonaId];
    createdAt = json[kKeyCreatedAt];
    id = json[kKeyId];
    conversations = json[kKeyConversations];
  }
}
