import 'package:chatbot/bot_profile/model/botprofilescreen_model.dart';
import 'package:chatbot/conversations/data/models/persona_model.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/common_ui/arrow_left_svg_icon.dart';
import 'package:chatbot/core/common_ui/cached_circle_avatar.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/main_prod.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'online_status_widget.dart';

GestureDetector messageSendButtonBuilder(void onSend()) {
  return GestureDetector(
    onTap: onSend,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        ImagePaths.msgSendButton,
        color: Theme.of(navigatorKey.currentContext!).primaryColor,
      ),
    ),
  );
}

PreferredSize chatScreenAppBar(
    BuildContext context, ChatUser chatBot, SchemaBotModel bot) {
  // final bool isOnline = bot.persona?.isAvailable ?? false;
  final String status = bot.persona?.status ?? PersonaModel.kKeyInactive;
  final String imageUrl = bot.persona?.image ?? ImagePaths.defaultNetworkImage;
  return CommonWidgets.customAppBar(
      context,
      Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: ArrowLeftSVGIcon()),
          SizedBox(width: 17.w),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.botProfileScreen,
                  arguments: BotProfileScreenModel(
                      schemaBotModel: bot, isChoosingBot: false));
            },
            child: Row(children: [
              CachedCircleAvatar(imageUrl: imageUrl),
              SizedBox(width: 20.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "${chatBot.firstName} ${chatBot.lastName}",
                    isBold: true,
                    size: 20.sp,
                    textColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 1.h),
                  OnlineStatusWidget(status: status)
                ],
              )
            ]),
          )
        ],
      ));
}
