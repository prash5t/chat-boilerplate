import 'dart:io';
import 'package:chatbot/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/text_constants.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.darkPrimaryColor,
  fontFamily: TextConstants.nunitoFont,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkPrimaryColor,
    primaryContainer: Color(0xFFF5F5F5),
    onPrimary: AppColors.blackBGForDarkTheme,
    secondary: Color(0xFF9E9E9E),
    onSecondary: Colors.black12,
    background: Colors.black,
    tertiary: AppColors.unCheckedColorDarkTheme,
    onTertiary: AppColors.bgColorOfBotMsgDarkTheme,
    // Define other colors for dark theme
  ),
  iconTheme: const IconThemeData(
    color: AppColors.darkPrimaryColor,
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.grey[800],
    systemOverlayStyle: Platform.isIOS
        ? SystemUiOverlayStyle.light
        : const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 15.sp,
    ),
    actionsIconTheme: const IconThemeData(color: Color(0xFFF5F5F5)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    backgroundColor: AppColors.blackBGForDarkTheme,
    foregroundColor: Colors.white,
    textStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
  )),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
    backgroundColor: Colors.black54,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all(Colors.white),
    checkColor: MaterialStateProperty.all(Colors.black),
  ),
);
