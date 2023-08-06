import 'package:chatbot/conversations/data/models/available_bots_model.dart';

class UserProfileModel {
  String? userId;
  String? phoneNumber;
  String? createdAt;
  List<dynamic>? userRole;
  AvailableBotsModel? availableBots;
  UserProfileModel(
      {this.userId,
      this.phoneNumber,
      this.createdAt,
      this.userRole,
      this.availableBots});
  static const String kKeyId = "id";
  static const String kKeyPhoneNumber = "phoneNumber";
  static const String kKeyCreatedAt = "createdAt";
  static const String kKeyUserRole = "userRole";
  UserProfileModel.fromJson(Map<String, dynamic> json) {
    userId = json[kKeyId];
    phoneNumber = json[kKeyPhoneNumber];
    createdAt = json[kKeyCreatedAt];
    userRole = json[kKeyUserRole];
    availableBots = AvailableBotsModel.fromJson(json);
  }
}
