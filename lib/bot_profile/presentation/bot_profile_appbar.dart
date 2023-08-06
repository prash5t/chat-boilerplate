import 'package:chatbot/core/common_ui/arrow_left_svg_icon.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PreferredSize buildBotProfileAppBar(BuildContext context) {
  return CommonWidgets.customAppBar(
      context,
      Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: ArrowLeftSVGIcon()),
          SizedBox(width: 17.w),
          CustomText(
            text: "User Profile",
            isBold: true,
            size: 20,
            textColor: Theme.of(context).primaryColor,
          )
        ],
      ));
}
