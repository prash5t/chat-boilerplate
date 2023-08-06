import 'package:chatbot/core/common_ui/bool_buttomsheet.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/constants/app_colors.dart';
import 'package:chatbot/core/constants/event_names.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/core/themes/dark_theme.dart';
import 'package:chatbot/core/themes/theme_cubit/cubit/theme_cubit.dart';
import 'package:chatbot/core/utils/analytics/analytics_functions.dart';
import 'package:chatbot/login/bloc/auth_bloc.dart';
import 'package:chatbot/main_prod.dart';
import 'package:chatbot/menu/bloc/cubit/acc_delete_cubit.dart';
import 'package:chatbot/menu/widgets/custom_list_tile_menu_screen.dart';
import 'package:chatbot/menu/widgets/menu_appbar_widget.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.customAppBar(
          context, buildAppBarForMenuScreen(context)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.color_lens_outlined),
              title: CustomText(
                text: "Theme",
                isBold: true,
                textColor: Theme.of(context).primaryColor,
              ),
              trailing: BlocBuilder<ThemeCubit, ThemeData>(
                builder: (context, currentTheme) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: DayNightSwitch(
                        value: currentTheme == darkTheme,
                        onChanged: (bool val) {
                          BlocProvider.of<ThemeCubit>(context).changeTheme();
                        }),
                  );
                },
              ),
            ),
            Divider(),
            CustomListTile(
              title: "Logout",
              leadingIcon: Icons.logout,
              titleColor: Theme.of(context).primaryColor,
              onTap: () async {
                await logoutUser(context);
              },
            ),
            Divider(),
            BlocConsumer<AccDeleteCubit, AccDeleteState>(
              listener: (context, state) {
                if (state == AccDeleteState.errorDeleting) {
                  CommonWidgets.customSnackBar(
                      context, TextConstants.errorDeletingAccount);
                } else if (state == AccDeleteState.deleted) {
                  BlocProvider.of<AuthBloc>(context).add(LogoutClickedEvent());
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    CustomListTile(
                      title: (state == AccDeleteState.deleting)
                          ? TextConstants.deletingAccountText
                          : TextConstants.deleteAccountText,
                      leadingIcon: Icons.delete_outline,
                      onTap: () async {
                        await deleteUser(context);
                      },
                      titleColor: AppColors.redFailColor,
                    ),
                    if (state == AccDeleteState.deleting)
                      LinearProgressIndicator(
                        minHeight: 1,
                        color: AppColors.redFailColor,
                      )
                  ],
                );
              },
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  Future<void> deleteUser(BuildContext context) async {
    bool shouldDeleteAcc = await booleanBottomSheet(
            context: context,
            titleText: TextConstants.deleteThisAccount,
            bgColorOfPrimaryButton: AppColors.redFailColor,
            colorOfTextInPrimaryButton: Colors.white,
            boolTrueText: TextConstants.deleteAccText) ??
        false;
    if (shouldDeleteAcc) {
      BlocProvider.of<AccDeleteCubit>(context).deleteUserAccount();
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    bool shouldLogout = await booleanBottomSheet(
            context: context,
            titleText: TextConstants.logoutTtile,
            boolTrueText: TextConstants.logoutText) ??
        false;
    if (shouldLogout) {
      BlocProvider.of<AuthBloc>(navigatorKey.currentContext!)
          .add(LogoutClickedEvent());
      logEventInAnalytics(EventNames.clickLogout);
    }
  }
}
