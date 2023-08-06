// below class is used to deserialize data of values in chatbots array of schema
import 'package:chatbot/conversations/data/models/persona_model.dart';

class SchemaBotModel {
  String? chatbotId;
  String? personaId;
  PersonaModel? persona;
  List<dynamic>? conversations;
  String? lastUpdatedMessagesTs;
  String? lastConversation;
  bool? isRead;
  SchemaBotModel(
      {this.chatbotId,
      this.personaId,
      this.persona,
      this.conversations,
      this.lastUpdatedMessagesTs,
      this.lastConversation,
      this.isRead});
  static const String kKeyChatBotId = 'chatbotId';
  static const String kKeyPersonaId = 'personaId';
  static const String kKeyPersona = 'persona';
  static const String kKeyConversations = 'conversations';
  static const String kKeyLastUpdatedMessageTS = 'lastUpdatedMessageTs';
  static const String kKeyLastConversation = 'lastConversation';
  static const String kKeyImage = 'image';
  static const String kKeyIsRead = 'isRead';
  SchemaBotModel.fromJson(Map<String, dynamic> json) {
    chatbotId = json[kKeyChatBotId];
    personaId = json[kKeyPersonaId];
    persona = PersonaModel.fromJson(json[kKeyPersona]);
    conversations = json[kKeyConversations];
    lastUpdatedMessagesTs = json[kKeyLastUpdatedMessageTS];
    lastConversation = json[kKeyLastConversation];
    isRead = json[kKeyIsRead];
  }
  Map<String, dynamic> toJson() {
    return {
      kKeyChatBotId: chatbotId,
      kKeyPersonaId: personaId,
      kKeyPersona: persona?.toJson(),
      kKeyConversations: conversations,
      kKeyLastUpdatedMessageTS: lastUpdatedMessagesTs,
      kKeyLastConversation: lastConversation,
      kKeyIsRead: isRead
    };
  }
}
