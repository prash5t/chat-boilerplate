import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeWidget extends StatelessWidget {
  final bool inOTPScreen;
  const WelcomeWidget({super.key, this.inOTPScreen = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: inOTPScreen
                ? Image.asset(
                    ImagePaths.robotPNG,
                    width: 180.w,
                    height: 180.h,
                  )
                : SvgPicture.asset(
                    ImagePaths.chatIcon,
                    width: 180.w,
                    height: 180.h,
                  ),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: TextConstants.welcomeText,
            size: 27.sp,
            isBold: true,
          ),
          const Text(TextConstants.welcomeDesc),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
            child: Divider(
              thickness: 0.5.sp,
            ),
          ),
        ],
      ),
    );
  }
}
