import 'package:chatbot/bot_profile/model/botprofilescreen_model.dart';
import 'package:chatbot/chat/presentation/online_status_widget.dart';
import 'package:chatbot/conversations/data/models/persona_model.dart';
import 'package:chatbot/core/common_ui/cached_circle_avatar.dart';
import 'package:chatbot/core/constants/event_names.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/conversations/cubit/delete_conversation_cubit.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/utils/date_to_string.dart';
import 'package:chatbot/core/utils/analytics/analytics_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ConversationListTile extends StatefulWidget {
  final SchemaBotModel bot;

  const ConversationListTile({super.key, required this.bot});

  @override
  State<ConversationListTile> createState() => _ConversationListTileState();
}

class _ConversationListTileState extends State<ConversationListTile> {
  @override
  Widget build(BuildContext context) {
    SchemaBotModel bot = widget.bot;
    PersonaModel? persona = bot.persona;
    bool isRead = bot.isRead ?? true;
    // bool isOnline = persona?.isAvailable ?? false;
    String status = persona?.status ?? PersonaModel.kKeyInactive;
    String imageUrl = persona?.image ?? ImagePaths.defaultNetworkImage;

    return BlocBuilder<DeleteConversationCubit, DeleteConversationState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: state.isDeleting
            ? null
            : () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.chatScreen, arguments: widget.bot);
                logEventInAnalytics(EventNames.clickOpenChat);
              },
        child: Column(
          children: [
            Slidable(
              endActionPane: state.isDeleting
                  ? null
                  : ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          BlocProvider.of<ConversationlistCubit>(context)
                              .deleteConversationWithThisBot(
                                  widget.bot.chatbotId!);
                          logEventInAnalytics(
                              EventNames.clickDeleteConversation);
                        },
                        icon: CupertinoIcons.delete,
                        backgroundColor: Colors.red,
                      )
                    ]),
              child: Stack(
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            AppRoutes.botProfileScreen,
                            arguments: BotProfileScreenModel(
                                schemaBotModel: widget.bot,
                                isChoosingBot: false));
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CachedCircleAvatar(imageUrl: imageUrl),
                          AvailabilityIconWidget(
                              status: status, widthHeight: 11)
                        ],
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${widget.bot.persona?.firstName} ${widget.bot.persona?.lastName}"),
                        CustomText(
                          text: dateToString(widget.bot.lastUpdatedMessagesTs),
                          size: 12.sp,
                        )
                      ],
                    ),
                    subtitle: Text(
                      widget.bot.lastConversation ?? TextConstants.noMsgHistory,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: !isRead ? FontWeight.bold : null),
                    ),
                    trailing: const Icon(
                      CupertinoIcons.forward,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.0.sp),
              child: (state.isDeleting &&
                      state.idOfBotToDelete == widget.bot.chatbotId)
                  ? const LinearProgressIndicator(
                      minHeight: 1,
                    )
                  : const Divider(
                      thickness: 0.5,
                    ),
            )
          ],
        ),
      );
    });
  }
}
