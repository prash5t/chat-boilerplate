import 'dart:convert';
import 'package:chatbot/chat/models/schema_message_model.dart';
import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/data/repository/conversation_repo.dart';
import 'package:chatbot/core/utils/schema_helper.dart';
import 'package:chatbot/core/utils/secure_storage_helper.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/core/utils/split_msg_to_list.dart';
import 'package:chatbot/main_prod.dart';
import 'package:chatbot/notifications/app_notifications.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.conversationRepo) : super(ChatLoadingState());
  final ConversationRepo conversationRepo;
  final SecureStorageHelper secureStorage = SecureStorageHelper();

  SchemaHelper schemaHelper = locator<SchemaHelper>();
//fyi: invoked to load conversation with a bot
  void loadConversationHistory(SchemaBotModel bot) async {
    emit(ChatLoadingState(chatBotId: bot.chatbotId));
    // get conversation history
    List<ChatMessage> conversationHistory =
        await addNewMsgAndGetAllMessages(bot: bot);

    emit(ChatLoadedState(
        conversationHistory: conversationHistory, chatBotId: bot.chatbotId!));
  }

//fyi: invoked when user sends new msg to bot
  void sendNewMessageToBot(ChatMessage userNewMsg, SchemaBotModel bot) async {
    Map<String, dynamic> botDesc = {
      SchemaMessageModel.kKeyRole: SchemaMessageModel.kKeySystemRole,
      SchemaMessageModel.kKeyContent: bot.persona?.description,
    };
    List<ChatMessage> conversationWithUserNewMsg =
        await addNewMsgAndGetAllMessages(bot: bot, chatMsg: userNewMsg);
    // Retrieve messages from the bot
    List<dynamic> ongoingConversation =
        await schemaHelper.getConversationWithBot(bot.chatbotId!);
    emit(ChatLoadedState(
        conversationHistory: conversationWithUserNewMsg,
        chatBotId: bot.chatbotId!));
    BlocProvider.of<ConversationlistCubit>(navigatorKey.currentContext!)
        .loadAvailableBots();

    ChatUser chatUserBot = ChatUser(
        id: bot.chatbotId!,
        firstName: bot.persona?.firstName,
        lastName: bot.persona?.lastName);
    final String botFullName =
        "${chatUserBot.firstName} ${chatUserBot.lastName}";

    // In the schema, conversations are stored in descending order based on time
    // For example: ['latest_msg', 'msg_at_3pm', 'msg_at_2pm']
    // The above order is necessary for the dash_chat_2 package to display ongoing chats correctly
    // The backend requires the latest message to be at the last index,
    // so the conversation is reversed before being provided to the backend
    List<dynamic> convoReversed = ongoingConversation.reversed.toList();
    convoReversed.insert(0, botDesc);
    debugPrint("msg along with context: $convoReversed");

    String newBotMsg = "";
    bool botReplied = true;
    final response =
        await conversationRepo.getNewMessage(convoReversed, bot.chatbotId!);
    response.fold((l) {
      botReplied = l.botReplied!;
      newBotMsg = l.content?.trim() ?? "";
    }, (r) {
      newBotMsg = TextConstants.botMsgWhenError;
    });
    if (botReplied) {
      List<String> splittedMessagesFromBot =
          splitMessageIntoSentences(newBotMsg.trim());
      debugPrint("debug splitted: $splittedMessagesFromBot");
      for (int index = 0; index < splittedMessagesFromBot.length; index++) {
        ChatMessage msgFromBot = ChatMessage(
            text: splittedMessagesFromBot[index],
            user: chatUserBot,
            createdAt: DateTime.now());
        List<ChatMessage> conversationWithBotNewMsg =
            await addNewMsgAndGetAllMessages(
                sentByBot: true, bot: bot, chatMsg: msgFromBot);

        // Check if the app is in the background/inactive
        final isAppInBackgroundOrInactive =
            (WidgetsBinding.instance.lifecycleState ==
                    AppLifecycleState.inactive) ||
                (WidgetsBinding.instance.lifecycleState ==
                    AppLifecycleState.paused);

        // fyi:  If app is in background/inactive, we show message as a notification
        if (isAppInBackgroundOrInactive) {
          AppNotifications.showNotification(
              title: botFullName,
              body: msgFromBot.text,
              payload:
                  jsonEncode({SchemaBotModel.kKeyChatBotId: bot.chatbotId}));
        }
// if its the last message from a response, we dont have to go to bot typing state again,
// so breaking the loop if its last msg

        bool thisIsLastMsg = splittedMessagesFromBot.length - index == 1;
        if (thisIsLastMsg) {
          BlocProvider.of<ConversationlistCubit>(navigatorKey.currentContext!)
              .loadAvailableBots();
          break;
        }

        emit(ChatLoadedState(
            conversationHistory: conversationWithBotNewMsg,
            chatBotId: bot.chatbotId!));
        BlocProvider.of<ConversationlistCubit>(navigatorKey.currentContext!)
            .loadAvailableBots();
        await Future.delayed(const Duration(seconds: 2));
        emit(BotTypingState(
            conversationHistory: conversationWithBotNewMsg,
            chatBotId: bot.chatbotId!,
            typingUsers: [chatUserBot]));
        // assuming human takes around  1 second to type 10characters
        int secondsBotShouldBeTyping =
            (splittedMessagesFromBot[index + 1].length / 10).ceil();
        debugPrint("time to wait: $secondsBotShouldBeTyping");
        await Future.delayed(Duration(seconds: secondsBotShouldBeTyping));
      }
      // when all the splitted bots messages are fetched, change to chat loaded state
      List<ChatMessage> updatedConvo =
          await addNewMsgAndGetAllMessages(bot: bot);
      emit(ChatLoadedState(
          conversationHistory: updatedConvo, chatBotId: bot.chatbotId!));
    }
  }

  Future<List<ChatMessage>> addNewMsgAndGetAllMessages(
      {ChatMessage? chatMsg,
      bool sentByBot = false,
      required SchemaBotModel bot}) async {
    List<dynamic> conversationHistory =
        await schemaHelper.getConversationWithBot(bot.chatbotId!);

    List<ChatMessage> previousConversation = [];
    if (chatMsg != null) {
      Map<String, dynamic> msgAsInSchemaFormat = {
        SchemaMessageModel.kKeyRole: sentByBot
            ? SchemaMessageModel.kKeyAssistantRole
            : SchemaMessageModel.kKeyUserRole,
        SchemaMessageModel.kKeyContent: chatMsg.text.trim(),
        SchemaMessageModel.kKeyCreatedAt: chatMsg.createdAt.toString()
      };
      // add new msg to history
      conversationHistory.insert(0, msgAsInSchemaFormat);
      await schemaHelper.updateMessagesWithThisBot(
          bot.chatbotId!, conversationHistory, chatMsg.text, chatMsg.createdAt);
    }
    // now return updated messages
    List<dynamic> updatedConversationHistory =
        await schemaHelper.getConversationWithBot(bot.chatbotId!);
    for (Map<String, dynamic> jsonMsg in updatedConversationHistory) {
      ChatUser msgSender;
      if (jsonMsg[SchemaMessageModel.kKeyRole] ==
          SchemaMessageModel.kKeyUserRole) {
        String? userId =
            locator<SharedPreferences>().getString(SharedPrefsKeys.userId);
        msgSender = ChatUser(id: userId!);
      }
      // when role is assistant or system
      else {
        msgSender = ChatUser(
            id: bot.chatbotId!,
            firstName: bot.persona?.firstName,
            lastName: bot.persona?.lastName);
      }
      final ChatMessage chatMsg = ChatMessage(
          text: jsonMsg[SchemaMessageModel.kKeyContent],
          user: msgSender,
          createdAt: DateTime.parse(jsonMsg[SchemaMessageModel.kKeyCreatedAt]));

      previousConversation.add(chatMsg);
    }
    return previousConversation;
  }
}
