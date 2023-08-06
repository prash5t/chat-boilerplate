import 'package:chatbot/core/common_ui/arrow_left_svg_icon.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Row buildAppBarForMenuScreen(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: ArrowLeftSVGIcon()),
      CustomText(
        text: "Menu",
        size: 20.sp,
        isBold: true,
        textColor: Theme.of(context).primaryColor,
      ),
      SizedBox(width: 20.w)
    ],
  );
}
