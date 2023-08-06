import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';

// this bottom sheet to be used in places like:
// onWillPop property, post delete feature
// takes title text, yes/true button text
Future<bool?> booleanBottomSheet(
    {required BuildContext context,
    required String titleText,
    Color? bgColorOfPrimaryButton,
    Color? colorOfTextInPrimaryButton,
    required String boolTrueText}) {
  return showModalBottomSheet<bool>(
    elevation: 1,
    context: context,
    isScrollControlled: true,
    shape: CommonWidgets.buildCircularBorderOnTop15r(),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(18.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Container(color: Colors.grey, width: 48.w, height: 4.h)),
            SizedBox(height: 8.h),
            CustomText(
              text: titleText,
              size: 15.sp,
              isBold: true,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: bgColorOfPrimaryButton),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomText(
                  text: boolTrueText,
                  isBold: true,
                  textColor: colorOfTextInPrimaryButton,
                ),
              ),
            ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0.h),
              child: InkWell(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 48.h,
                      child: const CustomText(text: "Cancel"))),
            )
          ],
        ),
      );
    },
  );
}
