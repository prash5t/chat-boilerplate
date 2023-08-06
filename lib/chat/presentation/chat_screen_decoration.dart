import 'package:chatbot/core/constants/app_colors.dart';
import 'package:chatbot/core/constants/app_constants.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/main_prod.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// using in message inputing text field of chat screen
InputDecoration messageInputDecoration() {
  return defaultInputDecoration(
      fillColor: Colors.transparent,
      hintStyle: TextStyle(
          color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.bold),
      hintText: TextConstants.writeYourMsgHint);
}

// using in message inputing toolbar of chat screen
BoxDecoration messageInputToolbarStyle() {
  return BoxDecoration(
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onSecondary,
    borderRadius: BorderRadius.circular(30.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 4.r,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

// style of message (either send by user or by bot)
TextStyle messageStyle(bool isMsgOfUser) {
  return TextStyle(
      fontSize: 13,
      color: isMsgOfUser
          ? Colors.white
          : Theme.of(navigatorKey.currentContext!).colorScheme.primaryContainer,
      fontWeight: isMsgOfUser ? FontWeight.bold : null);
}

// box decoration of message (either send by user or by bot)
BoxDecoration messageBoxDecoration(bool isMsgOfUser) {
  return defaultMessageDecoration(
    color: isMsgOfUser
        ? AppColors.primaryColor
        : Theme.of(navigatorKey.currentContext!).colorScheme.onTertiary,
    borderTopLeft: AppConstants.borderRadiusOfBubbleMsg,
    borderTopRight: isMsgOfUser ? 0 : AppConstants.borderRadiusOfBubbleMsg,
    borderBottomLeft: isMsgOfUser ? AppConstants.borderRadiusOfBubbleMsg : 0,
    borderBottomRight: AppConstants.borderRadiusOfBubbleMsg,
  );
}
