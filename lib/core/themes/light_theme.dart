import 'dart:io';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

final lightTheme = ThemeData(
    brightness: Brightness.light,
    // useMaterial3: true,
    fontFamily: TextConstants.nunitoFont,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      primaryContainer: Color(0xFF212121),
      onPrimary: AppColors.primaryColor,
      secondary: Colors.white,
      onSecondary: Colors.white,
      tertiary: AppColors.unCheckedColorLightTheme,
      onTertiary: AppColors.bgColorOfBotMsgLightTheme,
      // error: Colors.red,
      // onError: Colors.red,
      background: Colors.white,
      // onBackground: Colors.white,
      // surface: Colors.white,
      // onSurface: AppColors.primaryColor,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primaryColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(AppColors.primaryColor),
      checkColor: MaterialStateProperty.all(Colors.white),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.withOpacity(0.5),
    ),
    // dialogBackgroundColor: Colors.white,

    // dialogTheme: DialogTheme(
    //   backgroundColor: Colors.white,
    //   contentTextStyle: TextStyle(
    //     color: AppColors.lightTextColor,
    //     fontSize: 16.sp,
    //     fontWeight: FontWeight.normal,
    //   ),
    //   titleTextStyle: TextStyle(
    //     color: AppColors.lightTextColor,
    //     fontSize: 18.sp,
    //     fontWeight: FontWeight.normal,
    //   ),
    // ),

    // radioTheme: RadioThemeData(
    //     fillColor: MaterialStateProperty.all(AppColors.primaryColor)),
    // cardColor: Colors.white,
    // switchTheme: SwitchThemeData(
    //     thumbColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
    //     trackColor:
    //         MaterialStateProperty.all(const Color.fromRGBO(35, 116, 225, 0.2))),
    // scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      textStyle: TextStyle(color: Colors.white, fontSize: 18.sp),
    )),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: Platform.isIOS
          ? SystemUiOverlayStyle.dark
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 15.sp,
      ),
      actionsIconTheme: const IconThemeData(color: AppColors.lightTextColor),
    ),
    // bottomAppBarTheme: BottomAppBarTheme(
    //     // color: AppColors.lightScaffoldColor,
    //     ),
    // bottomAppBarColor: AppColors.lightScaffoldColor,
    hintColor: Colors.grey,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.primaryColor,
    ),
    listTileTheme: ListTileThemeData(iconColor: AppColors.primaryColor));
