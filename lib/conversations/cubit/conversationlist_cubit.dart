import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/conversations/cubit/delete_conversation_cubit.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/data/repository/conversation_repo.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/internet_connectivity_cubit/internet_connectivity_cubit.dart';
import 'package:chatbot/core/utils/schema_helper.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/main_prod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conversationlist_state.dart';

class ConversationlistCubit extends Cubit<ConversationlistState> {
  ConversationlistCubit(this.conversationRepo)
      : super(ConversationsLoadingState());
  final ConversationRepo conversationRepo;
  SchemaHelper schemaHelper = locator<SchemaHelper>();

  void resetToConversationLoadingState() {
    emit(ConversationsLoadingState());
  }

  void loadAvailableBots({Function()? syncFollowups}) async {
    // fetch available bots locally
    List<SchemaBotModel> ongoingChats = await schemaHelper.getAvailableBots();

    if (ongoingChats.isNotEmpty) {
      debugPrint("Convo/bot exists locally for this user");
      emit(ConversationsLoadedState(availableBots: ongoingChats));
    }
    // when bots are not available locally, try to fetch from network
    else {
      final bool internetAvailable =
          await BlocProvider.of<InternetConnectivityCubit>(
                  navigatorKey.currentContext!)
              .isInternetConnected();

      if (internetAvailable) {
        final response = await conversationRepo.getProfileAndBots();

        response.fold((l) async {
          // if no conversation/bot exists, need to navigate user towards creating first bot/convo
          if (l.availableBots == null || l.availableBots!.chatbots!.isEmpty) {
            debugPrint("No existing bots of this user");
            emit(ConversationsLoadedState(availableBots: []));
            searchNewBot();
          }
          // when user's bots are available on network,
          // save it to locally and display as well
          else {
            debugPrint("Convo/bot exists on network for this user");
            // update chatbot schema
            await schemaHelper.updateChatBots(l);
            List<SchemaBotModel> ongoingChats =
                await schemaHelper.getAvailableBots();
            emit(ConversationsLoadedState(availableBots: ongoingChats));
          }
        }, (r) {
          return emit(ErrorState(errorMsg: r.message, isInternetError: false));
        });
      }
      // internet not available case
      else {
        return emit(ErrorState(
            isInternetError: true, errorMsg: TextConstants.noInternetMsg));
      }
    }
    if (syncFollowups != null) {
      syncFollowups();
    }
  }

  void searchNewBot() async {
    final bool internetAvailable =
        await BlocProvider.of<InternetConnectivityCubit>(
                navigatorKey.currentContext!)
            .isInternetConnected();
    if (internetAvailable) {
      emit(ChooseNewBotState());
    } else {
      CommonWidgets.toastMsg(TextConstants.noInternetMsg);
    }
  }

  void deleteConversationWithThisBot(String idOfBotToDelete) async {
    BlocProvider.of<DeleteConversationCubit>(navigatorKey.currentContext!)
        .setConversationDeleting(idOfBotToDelete: idOfBotToDelete);
    // delete bot in network
    await conversationRepo.deleteThisBot(idOfBotToDelete);
    BlocProvider.of<DeleteConversationCubit>(navigatorKey.currentContext!)
        .setConversationDeleting(
            isDeleting: false, idOfBotToDelete: idOfBotToDelete);
    // delete bot in local
    await schemaHelper.deleteConversation(idOfBotToDelete);
    loadAvailableBots();
  }
}
