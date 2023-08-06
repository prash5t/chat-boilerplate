import 'package:bloc/bloc.dart';
import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/service_locator.dart';
import '../../dark_theme.dart';
import '../../light_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  getTheme() async {
    bool isDark = await locator<SharedPreferences>()
            .getBool(SharedPrefsKeys.isDarkMode) ??
        false;
    if (isDark) {
      emit(darkTheme);
      changeOverlayColor(true);
    } else {
      emit(lightTheme);
      changeOverlayColor(false);
    }
  }

  changeTheme() async {
    bool isDarkCurrently = state == darkTheme;
    locator<SharedPreferences>()
        .setBool(SharedPrefsKeys.isDarkMode, !isDarkCurrently);
    changeOverlayColor(!isDarkCurrently);
    emit(isDarkCurrently ? lightTheme : darkTheme);
  }
}

changeOverlayColor(bool isDark) {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}
