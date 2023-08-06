import 'package:chatbot/chat/presentation/chat_global_vars.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/utils/schema_helper.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/main_prod.dart';
import 'package:flutter/material.dart';

class NavHelper {
  // this method is useful to navigate to new screen and bring a value back to previous screen
  static Future<dynamic> returnValFromNav(
      BuildContext context, String routeName) async {
    return await Navigator.of(context).pushNamed(routeName);
  }

  static Future<void> navigateToChat(
      {required String? botId,
      bool appLaunchedFromNotification = false}) async {
    if (botId != null) {
      // if user is already not in this chat screen than only we need to navigate
      bool chatIsOpen = isChatScreenOpen[botId] ?? false;
      if (appLaunchedFromNotification ? true : !chatIsOpen) {
        List<SchemaBotModel> botData =
            await locator<SchemaHelper>().getAvailableBots(botId: botId);
        if (botData.isNotEmpty) {
          Navigator.of(navigatorKey.currentContext!)
              .pushNamed(AppRoutes.chatScreen, arguments: botData[0]);
        }
      }
    }
  }
}
