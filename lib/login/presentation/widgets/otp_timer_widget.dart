import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:flutter/material.dart';

class TimeLeftToSendNewOTPWidget extends StatelessWidget {
  final String timeInSeconds;

  const TimeLeftToSendNewOTPWidget({super.key, required this.timeInSeconds});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomText(text: "Resend OTP in "),
        CustomText(
            text: "0:$timeInSeconds", textColor: Theme.of(context).primaryColor)
      ],
    );
  }
}
