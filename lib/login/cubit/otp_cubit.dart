import 'package:chatbot/core/constants/app_constants.dart';
import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:chatbot/conversations/data/repository/conversation_repo.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/core/utils/analytics/analytics_functions.dart';
import 'package:chatbot/login/data/repository/auth_repo.dart';
import 'package:chatbot/main_prod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authbutton_cubit.dart';

part 'otp_state.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit(this.authRepo) : super(OTPSendingState());

  final AuthRepo authRepo;
  ConversationRepo conversationRepo = locator<ConversationRepo>();
  //fyi: useful when user clicks resend otp button
  triggerOTPSendingState() {
    emit(OTPSendingState());
  }

  triggerOTPSentState() async {
    // first keep emitting otp sent state with time remaining
    for (int secondsRemaining = AppConstants.timeToWaitForNewOTP;
        secondsRemaining > 0;
        secondsRemaining--) {
      String timeRemain = secondsRemaining.toString();
      if (secondsRemaining < 10) {
        timeRemain = "0$secondsRemaining";
      }
      emit(OTPIsSentState(secondsRemaining: timeRemain + 's'));
      await Future.delayed(const Duration(seconds: 1));
    }
    // after reaching remaining time, emit otp timeout state
    emit(OTPTimeoutState());
  }

  //fyi: after otp verification is complete, need to req backend for getting new access token
  reqAuthFromBackend() async {
    final respone = await authRepo.requestForAccessToken();
    respone.fold((l) async {
      debugPrint("Access token: ${l.accessToken}");
      locator<SharedPreferences>()
          .setString(SharedPrefsKeys.accessToken, l.accessToken!);
      final profileResp = await conversationRepo.getProfileAndBots();
      // whether profile resp is success or not, need to reset auth verifying state to false
      BlocProvider.of<AuthButtonCubit>(navigatorKey.currentContext!)
          .setAuthVerifying(isVerifying: false);
      // after getting access token, we fetch user's profile to get user id, phone number as well
      profileResp.fold((l) {
        // when profile is fetched
        locator<SharedPreferences>()
            .setString(SharedPrefsKeys.userId, l.userId!);
        locator<SharedPreferences>()
            .setString(SharedPrefsKeys.phoneNumber, l.phoneNumber!);
        locator<SharedPreferences>().setString(
            SharedPrefsKeys.userCreatedDateTime, l.createdAt.toString());
        setUserIdInAnalytics(l.userId!);
      }, (r) {
        // when profile info(user id, phone number) is not fetched
        return emit(ErrorFromBackendState(errorMsg: r.message!));
      });

      return emit(AuthVerifiedState());
    }, (r) {
      // case when access token cannot not be received
      BlocProvider.of<AuthButtonCubit>(navigatorKey.currentContext!)
          .setAuthVerifying(isVerifying: false);
      return emit(ErrorFromBackendState(errorMsg: r.message!));
    });
  }
}
