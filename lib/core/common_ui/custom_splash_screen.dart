import 'package:chatbot/core/constants/app_colors.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: AppColors.primaryColor,
        child: Center(
          child: SvgPicture.asset(
              // ImagePaths.splashLogoPNG,
              ImagePaths.splashLogo),
        ));
  }
}
