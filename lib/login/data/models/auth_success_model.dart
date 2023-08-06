class AuthSuccessModel {
  String? accessToken;

  AuthSuccessModel({this.accessToken});
  static const String kKeyAccessToken = 'access_token';
  AuthSuccessModel.fromJson(Map<String, dynamic> json) {
    accessToken = json[kKeyAccessToken];
  }
}
