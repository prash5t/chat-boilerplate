import 'package:chatbot/core/constants/firebase_error_codes.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:flutter/foundation.dart';

String getTrimmedFirebaseMsg(String untrimmedMsg) {
  debugPrint("untrimmed: $untrimmedMsg");
  final regex = RegExp(r"\[(.*?)\] (.*?)$");
  final match = regex.firstMatch(untrimmedMsg);

  if (match != null && match.groupCount >= 2) {
    final errorCode = match.group(1);
    final errorMsg = match.group(2);

    switch (errorCode) {
      case FirebaseErrors.invalidPhone:
        return TextConstants.invalidPhone;
      case FirebaseErrors.tooManyReq:
        return TextConstants.tooManyreq;
      case FirebaseErrors.invalidVerification:
        return TextConstants.wrongVerification;
      case FirebaseErrors.quotaExceeded:
        return TextConstants.quotaExceeded;
      default:
        return errorMsg ?? TextConstants.defaultErrorMsg;
    }
  }

  return untrimmedMsg;
}
