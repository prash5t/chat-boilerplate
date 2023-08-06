import 'package:chatbot/core/constants/countries_list.dart';
import 'package:chatbot/core/constants/event_names.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/internet_connectivity_cubit/internet_connectivity_cubit.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/routes/nav_helper.dart';
import 'package:chatbot/core/utils/text_field_validator.dart';
import 'package:chatbot/core/utils/analytics/analytics_functions.dart';
import 'package:chatbot/login/data/repository/get_countrycode.dart';
import 'package:chatbot/login/presentation/widgets/styles.dart';
import 'package:chatbot/login/presentation/widgets/terms_conditions_widget.dart';
import 'package:chatbot/login/presentation/widgets/welcome_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInWithPhoneNumberScreen extends StatefulWidget {
  const SignInWithPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<SignInWithPhoneNumberScreen> createState() =>
      _SignInWithPhoneNumberScreenState();
}

class _SignInWithPhoneNumberScreenState
    extends State<SignInWithPhoneNumberScreen> {
  bool? termsChecked = false;
  final _loginKey = GlobalKey<FormState>();
  final _enterPhoneNumber = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  String? dataResult;
  late String countryCodeToDisplay;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCountryPhoneCode();
  }

  @override
  void dispose() {
    super.dispose();
    _enterPhoneNumber.dispose();
  }

  Future getCountryPhoneCode() async {
    String isoCode = await getISOCode();
    if (mounted) {
      setState(() {
        countryCodeToDisplay =
            "+${countryList.firstWhere((element) => element.isoCode == isoCode, orElse: () => countryList.first).phoneCode}";
        countryCodeController.text = countryCodeToDisplay;

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const WelcomeWidget(),
                SizedBox(height: 40.h),
                Form(
                  key: _loginKey,
                  child: Container(
                    padding: EdgeInsets.all(16.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText(
                          text: 'Verification',
                          size: 18.sp,
                        ),
                        CustomText(
                          text: TextConstants.enterPhoneDesc,
                          textColor: Colors.grey,
                          size: 14.sp,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildCountryCodeSelectingWidget(context),
                            buildPhoneNumberEnteringWidget()
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.24,
                        ),
                        Row(
                          children: [
                            buildCheckBoxToAcceptTermsConditionsWidget(),
                            const TermsConditionsWidget(),
                            buildFloatingButtonToGoToOTPVerificationScreen(
                                context)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingButtonToGoToOTPVerificationScreen(
      BuildContext context) {
    return FloatingActionButton(
      onPressed: !termsChecked!
          ? null
          : () async {
              if (_enterPhoneNumber.text != "" &&
                  _loginKey.currentState!.validate()) {
                final bool internetAvailable =
                    await BlocProvider.of<InternetConnectivityCubit>(context)
                        .isInternetConnected();
                if (internetAvailable) {
                  Navigator.of(context).pushNamed(AppRoutes.otpScreen,
                      arguments: countryCodeToDisplay + _enterPhoneNumber.text);
                } else {
                  CommonWidgets.toastMsg(TextConstants.noInternetMsg);
                }
              }
            },
      elevation: 0,
      backgroundColor:
          !termsChecked! ? Theme.of(context).colorScheme.tertiary : null,
      child: const Icon(Icons.arrow_forward),
    );
  }

  Checkbox buildCheckBoxToAcceptTermsConditionsWidget() {
    return Checkbox(
        value: termsChecked,
        onChanged: (val) {
          setState(() {
            termsChecked = val;
          });
        });
  }

  Expanded buildPhoneNumberEnteringWidget() {
    return Expanded(
      child: TextFormField(
        maxLength: 15,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        keyboardType: TextInputType.number,
        controller: _enterPhoneNumber,
        autovalidateMode: AutovalidateMode.disabled,
        validator: (value) {
          return TextFieldValidator.phoneNumberValidator(value);
        },
        decoration:
            phoneNumberFieldDecorator(val: TextConstants.phoneNumberHint),
      ),
    );
  }

  Padding buildCountryCodeSelectingWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        onTap: () async {
          logEventInAnalytics(EventNames.clickCountryCode);
          dataResult = await NavHelper.returnValFromNav(
              context, AppRoutes.selectCountryScreen);
          setState(() {
            if (dataResult != null) {
              countryCodeToDisplay = dataResult!;
              countryCodeController.text = countryCodeToDisplay;
            }
          });
        },
        child: SizedBox(
            width: 75.w,
            child: TextFormField(
              controller: countryCodeController,
              enabled: false,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                label: isLoading
                    ? Center(
                        child: SizedBox(
                        width: 15.w,
                        height: 15.w,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      ))
                    : null,
                contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                border: outlineBorder(),
                disabledBorder: outlineBorder(),
              ),
            )),
      ),
    );
  }

  countryCodeFieldDecorator() {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        border: Border.all(width: 1.w, color: (Colors.grey[300])!));
  }
}
