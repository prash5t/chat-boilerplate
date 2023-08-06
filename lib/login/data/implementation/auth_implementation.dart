import 'package:chatbot/core/constants/network_constants.dart';
import 'package:chatbot/core/network/client/base_client.dart';
import 'package:chatbot/core/network/failure/failure.dart';
import 'package:chatbot/core/network/functions/get_parsed_data.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/login/bloc/auth_bloc.dart';
import 'package:chatbot/login/data/models/auth_success_model.dart';
import 'package:chatbot/login/data/repository/auth_repo.dart';
import 'package:chatbot/main_prod.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthImpl implements AuthRepo {
  final BaseClient _client;
  AuthImpl(this._client);

  //Instead of success, we will be returning custom model from here,
  //the model will be as per the response. and inside getParsedData function
  //send Model.fromJson as well

  ///fyi: this method is  called in the cases where user already have their signed in firebase auth instance
  /// it is used in places when existing access token is expired and need to get new token
  /// example: 1) while navigating to home after otp verification
  /// 2) when trying to use other endpoints with expired access token and need to recall with new access token
  @override
  Future<Either<AuthSuccessModel, Failure>> requestForAccessToken() async {
    FirebaseAuth auth = locator<FirebaseAuth>();
    if (auth.currentUser == null) {
      BlocProvider.of<AuthBloc>(navigatorKey.currentContext!)
          .add(LogoutClickedEvent());
      return getParsedData(null, null);
    }
    String firebaseToken = await auth.currentUser!.getIdToken();
    String? fcmToken;
    try {
      fcmToken = await locator<FirebaseMessaging>().getToken();
    } catch (e) {
      fcmToken = "";
      debugPrint("ERROR IN FCMTOKEN: $e");
    }
    debugPrint("firebase token: $firebaseToken");
    debugPrint("fcm token: $fcmToken");

    String path = "auth/auth-token?fcm_token=$fcmToken";
    final response = await _client.postRequest(
        baseUrl: NetworkConstants.baseUrl,
        path: path,
        data: {"token": firebaseToken});
    return getParsedData(
      response,
      AuthSuccessModel.fromJson,
    );
  }
}
