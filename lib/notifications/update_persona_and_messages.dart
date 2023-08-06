import 'package:chatbot/chat/cubit/chat_cubit.dart';
import 'package:chatbot/chat/models/schema_message_model.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/conversations/data/models/bot_model.dart';
import 'package:chatbot/conversations/data/models/persona_model.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/data/repository/conversation_repo.dart';
import 'package:chatbot/core/internet_connectivity_cubit/internet_connectivity_cubit.dart';
import 'package:chatbot/core/utils/schema_helper.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/main_prod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> updatePersonaAndMessages(BuildContext context) async {
  ConversationRepo conversationRepo = locator<ConversationRepo>();
  SchemaHelper schemaHelper = locator<SchemaHelper>();
  final bool internetAvailable =
      await BlocProvider.of<InternetConnectivityCubit>(
              navigatorKey.currentContext!)
          .isInternetConnected();
  if (internetAvailable) {
    final response = await conversationRepo.getProfileAndBots();
    response.fold((l) async {
      final List<BotModel> availableBots = l.availableBots?.chatbots ?? [];
      if (availableBots.isNotEmpty) {
        // with each of the bot
        for (BotModel eachBot in availableBots) {
          await schemaHelper.updatePersonaOfThisBot(eachBot);
          List<dynamic> msgsToSyncWithThisBot = eachBot.messages ?? [];
          debugPrint("msgs to sync: $msgsToSyncWithThisBot");
          if (msgsToSyncWithThisBot.isNotEmpty) {
            final List<dynamic> currentMsgsWithThisBot =
                await schemaHelper.getConversationWithBot(eachBot.botId!);
            for (Map<String, dynamic> eachMsg in msgsToSyncWithThisBot) {
              final DateTime currentTimeLocal = DateTime.now();
              final DateTime followUpTimeLocal =
                  DateTime.parse(eachMsg["followupTime"]).toLocal();
              final bool shouldSync =
                  currentTimeLocal.isAfter(followUpTimeLocal);
              debugPrint(
                  "currentTime: $currentTimeLocal, followUpTime: $followUpTimeLocal, shouldSync: $shouldSync");
              if (shouldSync) {
                Map<String, dynamic> eachMsgInSchemaFormat = {
                  SchemaMessageModel.kKeyRole:
                      eachMsg[SchemaMessageModel.kKeyRole],
                  SchemaMessageModel.kKeyContent:
                      eachMsg[SchemaMessageModel.kKeyContent],

                  /// fyi: follow up message have key called followupTime that have the time where msg should reach user
                  /// that is why below instead of using createdAt field, we are using followupTime field as createdAt time
                  SchemaMessageModel.kKeyCreatedAt:
                      eachMsg[SchemaMessageModel.kKeyFollowUpTime]
                };
                currentMsgsWithThisBot.insert(0, eachMsgInSchemaFormat);

                // now the messages list are updated, lets save it
                String lastConversation =
                    currentMsgsWithThisBot[0][SchemaMessageModel.kKeyContent];
                DateTime lastConversationTime = DateTime.parse(
                    currentMsgsWithThisBot[0]
                        [SchemaMessageModel.kKeyCreatedAt]);
                final msgIsUpdated =
                    await schemaHelper.updateMessagesWithThisBot(
                        eachBot.botId!,
                        currentMsgsWithThisBot,
                        lastConversation,
                        lastConversationTime);
                if (msgIsUpdated) {
                  // update messages in chat screen
                  BlocProvider.of<ChatCubit>(navigatorKey.currentContext!)
                      .loadConversationHistory(SchemaBotModel(
                          chatbotId: eachBot.botId,
                          persona: PersonaModel(
                              firstName: eachBot.persona?.firstName,
                              lastName: eachBot.persona?.lastName)));
                  // refreshing conversation list screen before we notify follow up is synced
                  BlocProvider.of<ConversationlistCubit>(
                          navigatorKey.currentContext!)
                      .loadAvailableBots();

                  // below need to hit the endpoint to notify follow up msgs are synced with this bot
                  await conversationRepo
                      .notifyFollowUpsAreSynced(eachBot.botId!);
                }
              }
            }
          }

          /// fyi: when there are no messages to sync, we still need to update conversation list screen
          /// to show synced online status of bot
          else {
            BlocProvider.of<ConversationlistCubit>(navigatorKey.currentContext!)
                .loadAvailableBots();
          }
        }

        debugPrint("Follow up synced");
        // CommonWidgets.customSnackBar(
        //     context, "Follow up messages synced (temporary widget)");
      } else {
        debugPrint("No bots, so no follow up messages to sync");
      }
    }, (r) {
      // case when error  receiving  available bots on network along with followup msg in model format
      debugPrint("Follow up error: ${r.message}");
    });
  }
}
