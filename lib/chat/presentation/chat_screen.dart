import 'package:chatbot/chat/cubit/chat_cubit.dart';
import 'package:chatbot/chat/presentation/chat_global_vars.dart';
import 'package:chatbot/chat/presentation/chat_loaded_screen.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/utils/schema_helper.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_widgets.dart';

class ChatScreen extends StatefulWidget {
  final SchemaBotModel bot;

  const ChatScreen({super.key, required this.bot});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  List<ChatMessage>? loadedMessages;

  @override
  void initState() {
    // when chat screen is opened, we set chat screen open as true
    isChatScreenOpen[widget.bot.chatbotId!] = true;
    markAsRead();
    BlocProvider.of<ChatCubit>(context).loadConversationHistory(widget.bot);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void markAsRead() async {
    bool isRead = widget.bot.isRead ?? true;
    // fyi: we only need to update isRead in schema if if its unread
    if (!isRead) {
      await locator<SchemaHelper>()
          .markConversationAsRead(botId: widget.bot.chatbotId!);
      BlocProvider.of<ConversationlistCubit>(context).loadAvailableBots();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    // when chat screen is disposed, we set chat screen open as false
    isChatScreenOpen[widget.bot.chatbotId!] = false;
  }

  @override
  Widget build(BuildContext context) {
    String? userId =
        locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
    final String imageUrl =
        widget.bot.persona?.image ?? ImagePaths.defaultNetworkImage;
    //below creating  ChatUser instance of bot and the user
    ChatUser chatBot = ChatUser(
        id: widget.bot.chatbotId!,
        profileImage: imageUrl,
        firstName: widget.bot.persona?.firstName,
        lastName: widget.bot.persona?.lastName);
    ChatUser chatPerson = ChatUser(id: userId!);
    return Scaffold(
        appBar: chatScreenAppBar(context, chatBot, widget.bot),
        body: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
          if (state is ChatLoadedState &&
              state.chatBotId == widget.bot.chatbotId) {
            loadedMessages = state.conversationHistory;
            return ChatLoadedWidget(
                user: chatPerson,
                conversationHistory: state.conversationHistory,
                bot: chatBot,
                schemaBotModel: widget.bot);
          } else if (state is BotTypingState &&
              state.chatBotId == widget.bot.chatbotId) {
            return ChatLoadedWidget(
              user: chatPerson,
              conversationHistory: state.conversationHistory,
              bot: chatBot,
              schemaBotModel: widget.bot,
              typingUsers: [chatBot],
            );
          } else if (state is ChatLoadingState &&
              state.chatBotId == widget.bot.chatbotId) {
            return const Center(child: CircularProgressIndicator());
          }
          return ChatLoadedWidget(
              conversationHistory: loadedMessages ?? [],
              bot: chatBot,
              user: chatPerson,
              schemaBotModel: widget.bot);
        }));
  }
}
