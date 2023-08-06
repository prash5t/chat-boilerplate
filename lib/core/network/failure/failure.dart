import 'package:chatbot/core/constants/text_constants.dart';

class Failure {
  String? message;

  Failure({this.message});

  ///WHENEVER FAILURE IS RECEIVED VIA API, I'M SUPPOSING FAILURE MESSAGE IS COMING
  ///IN KEY message, need to modify this as per project.
  Failure.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? TextConstants.defaultErrorMsg;
  }
}
