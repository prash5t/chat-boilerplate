part of 'otp_cubit.dart';

abstract class OTPState {}

//fyi: when otp is not sent yet
// can be initially after user provides phone number
// or can also be when user clicks resend otp button
// simply, its state when otp needs to be sent but not sent yet
// why this? in cases where user is filling captcha or firebase is verifying beforing sending otp, there is a waiting time
// so we are keeping this state
class OTPSendingState extends OTPState {}

// fyi: otp is sent only after user passes captcha or firebases verifys the user req to send otp
class OTPIsSentState extends OTPState {
  //fyi: secondsRemaining means seconds remaining to be able to send new otp
  String secondsRemaining;
  OTPIsSentState({required this.secondsRemaining});
}

class OTPTimeoutState extends OTPState {}

class AuthVerifiedState extends OTPState {}

class ErrorFromBackendState extends OTPState {
  final String errorMsg;
  ErrorFromBackendState({required this.errorMsg});
}
