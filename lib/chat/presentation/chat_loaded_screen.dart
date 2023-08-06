import 'package:chatbot/bot_profile/model/botprofilescreen_model.dart';
import 'package:chatbot/chat/cubit/chat_cubit.dart';
import 'package:chatbot/core/constants/event_names.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/internet_connectivity_cubit/internet_connectivity_cubit.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/utils/analytics/analytics_functions.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chat_screen_decoration.dart';
import 'chat_widgets.dart';

class ChatLoadedWidget extends StatefulWidget {
  final List<ChatMessage> conversationHistory;
  final ChatUser bot;
  final SchemaBotModel schemaBotModel;
  final ChatUser user;
  final List<ChatUser>? typingUsers;
  const ChatLoadedWidget(
      {super.key,
      required this.conversationHistory,
      this.typingUsers,
      required this.bot,
      required this.user,
      required this.schemaBotModel});

  @override
  State<ChatLoadedWidget> createState() => _ChatLoadedWidgetState();
}

class _ChatLoadedWidgetState extends State<ChatLoadedWidget> {
  @override
  Widget build(BuildContext context) {
    return DashChat(
      inputOptions: InputOptions(
          inputDecoration: messageInputDecoration(),
          inputToolbarStyle: messageInputToolbarStyle(),
          inputToolbarPadding: EdgeInsets.all(5.sp),
          inputToolbarMargin:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          alwaysShowSend: true,
          sendButtonBuilder: (onSend) {
            return messageSendButtonBuilder(onSend);
          }),
      currentUser: widget.user,
      messageOptions: chatbotMessageOptionsBuilder(),
      onSend: (ChatMessage userNewMsg) async {
        if (userNewMsg.text.trim() != "") {
          final bool internetAvailable =
              await BlocProvider.of<InternetConnectivityCubit>(context)
                  .isInternetConnected();
          if (internetAvailable) {
            BlocProvider.of<ChatCubit>(context)
                .sendNewMessageToBot(userNewMsg, widget.schemaBotModel);
            logEventInAnalytics(EventNames.clickMessageSend);
          } else {
            CommonWidgets.toastMsg(TextConstants.noInternetMsg);
          }
        }
      },
      typingUsers: widget.typingUsers,
      messages: widget.conversationHistory,
    );
  }

// used to customize message style and message box decoration
  MessageOptions chatbotMessageOptionsBuilder() {
    return MessageOptions(
      messagePadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      marginSameAuthor: EdgeInsets.only(top: 8.h),
      marginDifferentAuthor: EdgeInsets.only(top: 35.h),
      avatarBuilder: (chatUser, onPressAvatar, onLongPressAvatar) {
        return DefaultAvatar(
          user: widget.bot,
          size: 30.r,
          fallbackImage: AssetImage(ImagePaths.defaultDP),
          onPressAvatar: (chatUser) {
            Navigator.pushNamed(context, AppRoutes.botProfileScreen,
                arguments: BotProfileScreenModel(
                    schemaBotModel: widget.schemaBotModel,
                    isChoosingBot: false));
          },
        );
      },
      messageTextBuilder: (message, previousMessage, nextMessage) {
        bool isMsgOfUser = message.user.id == widget.user.id;
        return Text(
          message.text,
          style: messageStyle(isMsgOfUser),
        );
      },
      messageDecorationBuilder: (message, previousMessage, nextMessage) {
        bool isMsgOfUser = message.user.id == widget.user.id;
        return messageBoxDecoration(isMsgOfUser);
      },
    );
  }
}
