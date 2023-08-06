import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_text.dart';

Future<void> errorBottomSheet(
    {required BuildContext context,
    required String errorMsg,
    bool isInternetError = false}) {
  return showModalBottomSheet<void>(
      elevation: 1,
      context: context,
      isScrollControlled: true,
      shape: CommonWidgets.buildCircularBorderOnTop15r(),
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.all(18.sp),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Container(
                          color: Colors.grey, width: 48.w, height: 4.h)),
                  SizedBox(height: 10.h),
                  SvgPicture.asset(
                      isInternetError
                          ? ImagePaths.noInternetSVG
                          : ImagePaths.perrErrorSVG,
                      height: 200.h,
                      width: 200.h),
                  Text(
                    errorMsg,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 17.h),
                  SizedBox(
                      height: 50.h,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: CustomText(
                              text: "Okay",
                              isBold: true,
                              textColor: Colors.white)))
                ]));
      });
}
