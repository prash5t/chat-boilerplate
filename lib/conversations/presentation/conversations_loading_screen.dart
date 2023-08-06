import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ConversationsLoadingScreen extends StatelessWidget {
  final String loadingMessage;
  const ConversationsLoadingScreen({super.key, required this.loadingMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).primaryColor, size: 110.sp),
            SizedBox(height: 25.h),
            CustomText(text: loadingMessage)
          ],
        ),
      ),
    );
  }
}
