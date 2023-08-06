import 'package:chatbot/chat/models/schema_message_model.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/data/repository/conversation_repo.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/core/utils/schema_helper.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/main_prod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'choose_bot_state.dart';

class ChooseBotCubit extends Cubit<ChooseBotState> {
  ChooseBotCubit() : super(ChoosingBotState());

  ConversationRepo conversationRepo = locator<ConversationRepo>();
  SchemaHelper schemaHelper = locator<SchemaHelper>();

  void findRandomBot() async {
    emit(ChoosingBotState());
    final response = await conversationRepo.searchNewBot();
    response.fold((l) {
      return emit(BotIsReadyToShow(botToShow: l));
    }, (r) {
      return emit(ErrorChoosingBotState(
          errorMsg: r.message ?? TextConstants.errorSearchingBot));
    });
  }

  void startConversationWithThisBot(
      {required SchemaBotModel choosedBot}) async {
    emit(StartingConvoWithChoosedBotState(botToStartConvo: choosedBot));
    final response = await conversationRepo.createNewConversation(
        choosedBotId: choosedBot.personaId);
    response.fold((l) async {
      SchemaBotModel newBot = SchemaBotModel(
          chatbotId: l.id,
          personaId: l.personaId,
          persona: l.persona,
          conversations: l.conversations,
          lastUpdatedMessagesTs: l.conversations?[0]
              [SchemaMessageModel.kKeyCreatedAt],
          lastConversation: l.conversations?[0][SchemaMessageModel.kKeyContent],
          // when new convo is started, we navigate to chat screen
          // so setting isRead as true on starting new convo
          isRead: true);
      // first save new bot locally
      await schemaHelper.addNewConversation(newBot);
      //then proceed towards ui for chatting with this new bot
      emit(BotIsChoosedState(botToStartConvo: newBot));
      BlocProvider.of<ConversationlistCubit>(navigatorKey.currentContext!)
          .loadAvailableBots();
    }, (r) {
      return emit(ErrorStartingConvoState(
          errorMsg: r.message ?? TextConstants.errorStartingConvo));
    });
  }
}
