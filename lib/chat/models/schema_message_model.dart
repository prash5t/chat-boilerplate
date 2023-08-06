// below class is used to deserialize data of values in conversations array of each bot in chatbots
class SchemaMessageModel {
  String? role;
  String? content;
  String? createdAt;
  bool? botReplied;

  static const String kKeyRole = "role";
  static const String kKeyContent = "content";
  static const String kKeyCreatedAt = "createdAt";
  static const String kKeyFollowUpTime = "followupTime";
  static const String kKeybotReplied = "reply";

  /// msg can be from three entity which are (system, assistant and user)
  /// so below static constats are kept
  static const String kKeySystemRole = "system";
  static const String kKeyAssistantRole = "assistant";
  static const String kKeyUserRole = "user";

  SchemaMessageModel.fromJson(Map<String, dynamic> json) {
    role = json[kKeyRole];
    content = json[kKeyContent];
    createdAt = json[kKeyCreatedAt];
    botReplied = json[kKeybotReplied];
  }

  Map<String, dynamic> toJson() {
    return {kKeyRole: role, kKeyContent: content, kKeyCreatedAt: createdAt};
  }
}
