import 'package:chatbot/core/constants/app_colors.dart';
import 'package:chatbot/core/constants/network_constants.dart';
import 'package:chatbot/core/utils/launch_url.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsConditionsWidget extends StatefulWidget {
  const TermsConditionsWidget({super.key});

  @override
  State<TermsConditionsWidget> createState() => _TermsConditionsWidgetState();
}

class _TermsConditionsWidgetState extends State<TermsConditionsWidget> {
  TapGestureRecognizer _termsConditionRecognizer = TapGestureRecognizer();
  TapGestureRecognizer _privacyPolicyRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _termsConditionRecognizer.dispose();
    _privacyPolicyRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // checkTC();
    super.initState();

    _termsConditionRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchLink(NetworkConstants.termsUrl);
      };
    _privacyPolicyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchLink(NetworkConstants.privacyUrl);
      };
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text.rich(
        TextSpan(
            style: const TextStyle(
              fontSize: 13,
            ),
            text: "I agree to the ",
            children: [
              TextSpan(
                text: 'Terms & Conditions',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _termsConditionRecognizer,
              ),
              const TextSpan(
                text: ' and acknowledge that I have read the ',
              ),
              TextSpan(
                text: 'Privacy Policy',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _privacyPolicyRecognizer,
              ),
              const TextSpan(
                text: '.',
              ),
            ]),
      ),
    );
  }
}
