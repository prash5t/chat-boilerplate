import 'package:chatbot/core/constants/event_names.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/utils/analytics/analytics_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PreferredSize conversationsScreenAppBar(BuildContext context) {
  return CommonWidgets.customAppBar(
    context,
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildMenuButton(context),
        CustomText(
          text: "Messages",
          textColor: Theme.of(context).primaryColor,
          size: 20.sp,
          isBold: true,
        ),
        IconButton(
            onPressed: () {
              BlocProvider.of<ConversationlistCubit>(context).searchNewBot();
              logEventInAnalytics(EventNames.clickNewConversation);
            },
            icon: ImageIcon(
              AssetImage(
                ImagePaths.composeIcon,
              ),
              size: 24.sp,
            ))
      ],
    ),
  );
}

IconButton buildMenuButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.menuScreen);
      },
      icon: Icon(
        Icons.menu,
        size: 25.sp,
      ));
}
