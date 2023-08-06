import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.phoneNumberScreen);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0.sp, vertical: 16.sp),
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20.w),
                Expanded(
                    child: CustomText(
                  text: "Continue",
                  isBold: true,
                  size: 19.sp,
                  textColor: Theme.of(context).colorScheme.background,
                  alignCenter: true,
                )),
                Padding(
                  padding: EdgeInsets.only(right: 12.0.sp),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.background,
                    size: 24.sp,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Column(
                  children: [
                    CustomText(
                        text: TextConstants.appName,
                        textColor: Theme.of(context).primaryColor,
                        isBold: true,
                        size: 23.sp),
                    SizedBox(height: 14.h),
                    SizedBox(
                        width: 270.w,
                        child: Text(TextConstants.welcomeDesc,
                            textAlign: TextAlign.center))
                  ],
                ),
                SizedBox(height: 90.h),
                Image.asset(ImagePaths.onboardingImg,
                    height: 324.h, width: 320.w, fit: BoxFit.fill),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
