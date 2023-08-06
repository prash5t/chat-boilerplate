import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorLoadingConversationScreen extends StatelessWidget {
  const ErrorLoadingConversationScreen(
      {super.key, this.errorMsg, required this.isInternetError});
  final String? errorMsg;
  final bool isInternetError;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isInternetError
                ? SvgPicture.asset(ImagePaths.noInternetSVG,
                    width: 300.w, height: 300.h)
                : Image.asset(ImagePaths.robotPNG, width: 300.w, height: 300.h),
            CustomText(
              text: errorMsg ?? TextConstants.defaultErrorMsg,
              isBold: true,
              alignCenter: true,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 50.h,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<ConversationlistCubit>(context)
                        .loadAvailableBots();
                    // NavHelper.navigateAndRemovePrevious(
                    //     context, const ConversationsListScreen());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.conversationsListScreen, (route) => false);
                  },
                  child: const Text("Okay")),
            )
          ],
        ),
      ),
    );
  }
}
