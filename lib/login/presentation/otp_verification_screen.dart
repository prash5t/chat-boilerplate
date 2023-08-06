import 'package:chatbot/core/constants/event_names.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/internet_connectivity_cubit/internet_connectivity_cubit.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/utils/analytics/analytics_keys.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/core/utils/analytics/analytics_functions.dart';
import 'package:chatbot/core/firebase/remote_configs.dart';
import 'package:chatbot/login/cubit/authbutton_cubit.dart';
import 'package:chatbot/login/cubit/otp_cubit.dart';
import 'package:chatbot/login/presentation/widgets/otp_error_buttomsheet.dart';
import 'package:chatbot/login/presentation/widgets/otp_timer_widget.dart';
import 'package:chatbot/login/presentation/widgets/styles.dart';
import 'package:chatbot/login/presentation/widgets/welcome_widget.dart';
import 'package:chatbot/main_prod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({Key? key, required this.number})
      : super(key: key);
  final String number;

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpFieldController = TextEditingController();
  String? _verificationId;

  ///FYI user should only be able to verify otp once otp is sent from firebase
  bool _otpIsSent = false;

  final FirebaseAuth _auth = locator<FirebaseAuth>();

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  @override
  void dispose() {
    super.dispose();
    _otpIsSent = false;
    _otpFieldController.dispose();
    BlocProvider.of<AuthButtonCubit>(navigatorKey.currentContext!)
        .setAuthVerifying(isVerifying: false);

    /// FYI triggering initial state (otp sending state) on dispose
    /// bacause user might just go back from otp verification screen to phone number screen
    /// in that case, we need to reset otp verification screen to initial state
    // BlocProvider.of<OTPCubit>(navigatorKey.currentContext!)
    //     .triggerOTPSendingState();
  }

  Future<void> _verifyPhoneNumber() async {
    String firebaseToken = await _auth.currentUser?.getIdToken() ?? "";
    debugPrint(firebaseToken);
    RemoteConfigs.fetchAndActivateRemoteConfig();
    BlocProvider.of<OTPCubit>(context).triggerOTPSendingState();
    _auth.verifyPhoneNumber(
        phoneNumber: widget.number.trim(),
        verificationCompleted:
            (PhoneAuthCredential phonesAuthCredentials) async {},
        verificationFailed: (FirebaseAuthException verificationFailed) async {
          logEventInAnalytics(EventNames.otpNotSentError, parameters: {
            AnalyticsKeys.kKeyMessage: verificationFailed.message
          });
          Navigator.pop(context);
          await otpErrorBottomSheet(
              context: context, errorMsg: verificationFailed.toString());
        },
        codeSent: (String verificationId, int? resendingToken) async {
          BlocProvider.of<OTPCubit>(context).triggerOTPSentState();
          setState(() {
            _verificationId = verificationId;
            _otpIsSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) async {});
  }

  Future _sendCodeToFirebase({String? code}) async {
    final bool internetAvailable =
        await BlocProvider.of<InternetConnectivityCubit>(context)
            .isInternetConnected();
    if (!internetAvailable) {
      CommonWidgets.toastMsg(TextConstants.noInternetMsg);
      return;
    } else if (!mounted) {
      return;
    } else if (!_otpIsSent) {
      CommonWidgets.toastMsg(TextConstants.canOnlyVerifyOTPOnceSent);
      return;
    }
    BlocProvider.of<AuthButtonCubit>(context).setAuthVerifying();
    if (_verificationId != null) {
      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: code!);

      await _auth
          .signInWithCredential(credential)
          .then((value) async {
            BlocProvider.of<OTPCubit>(context).reqAuthFromBackend();
          })
          .whenComplete(() {})
          .onError((error, stackTrace) async {
            logEventInAnalytics(EventNames.otpVerificationError,
                parameters: {AnalyticsKeys.kKeyMessage: error.toString()});
            BlocProvider.of<AuthButtonCubit>(context)
                .setAuthVerifying(isVerifying: false);
            if (mounted) {
              await otpErrorBottomSheet(
                  context: context, errorMsg: error.toString());
              setState(() {
                _otpFieldController.text = "";
              });
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OTPCubit, OTPState>(
      listener: (context, state) {
        if (state is ErrorFromBackendState) {
          BlocProvider.of<AuthButtonCubit>(context)
              .setAuthVerifying(isVerifying: false);
          CommonWidgets.customSnackBar(context, state.errorMsg);
        } else if (state is AuthVerifiedState) {
          logEventInAnalytics(EventNames.login);
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.conversationsListScreen, (route) => false);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const WelcomeWidget(
                  inOTPScreen: true,
                ),
                SizedBox(height: 40.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(text: 'OTP Verification', size: 18.sp),
                      CustomText(
                        text: TextConstants.enter6DigitOTPDesc,
                        textColor: Colors.grey,
                        size: 14.sp,
                      ),
                      SizedBox(height: 20.h),
                      CustomText(
                        text: widget.number,
                        size: 15.sp,
                        textColor: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        onChanged: (value) async {
                          if (value.length == 6) {
                            _sendCodeToFirebase(code: value);
                          }
                        },
                        textAlign: TextAlign.start,
                        style: TextStyle(letterSpacing: 30.sp, fontSize: 30.sp),
                        maxLength: 6,
                        controller: _otpFieldController,
                        keyboardType: TextInputType.number,
                        autofillHints: const <String>[
                          AutofillHints.telephoneNumber
                        ],
                        decoration: phoneNumberFieldDecorator(
                            val: "______", vertialPadding: 14.h),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<OTPCubit, OTPState>(
                            builder: (context, state) {
                              if (state is OTPTimeoutState) {
                                return Row(
                                  children: [
                                    const Text(
                                        TextConstants.didNotReceiveOTPText),
                                    TextButton(
                                      onPressed: () async {
                                        logEventInAnalytics(
                                            EventNames.clickResendOTP);
                                        _verifyPhoneNumber();
                                      },
                                      child: const Text(
                                        TextConstants.resendOTPText,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              if (state is OTPIsSentState) {
                                return TimeLeftToSendNewOTPWidget(
                                    timeInSeconds: state.secondsRemaining);
                              }
                              // for otp sending state
                              return const Text(TextConstants.receivingOTPText);
                            },
                          ),
                          BlocBuilder<AuthButtonCubit, bool>(
                            builder: (context, isVerifying) {
                              return FloatingActionButton(
                                  onPressed: isVerifying
                                      ? null
                                      : () {
                                          if (_otpFieldController.text.length ==
                                              6) {
                                            _sendCodeToFirebase(
                                                code: _otpFieldController.text);
                                          } else {
                                            CommonWidgets.customSnackBar(
                                                context,
                                                TextConstants.invalidOTPLength);
                                          }
                                        },
                                  elevation: 0,
                                  child: isVerifying
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Icon(Icons.arrow_forward));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
