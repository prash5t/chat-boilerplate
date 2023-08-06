import 'package:chatbot/bot_profile/model/botprofilescreen_model.dart';
import 'package:chatbot/bot_profile/presentation/bot_profile_screen.dart';
import 'package:chatbot/chat/presentation/chat_screen.dart';
import 'package:chatbot/conversations/cubit/choose_bot_cubit.dart';
import 'package:chatbot/conversations/presentation/conversations_loading_screen.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:chatbot/core/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseNewBotScreen extends StatefulWidget {
  const ChooseNewBotScreen({super.key});

  @override
  State<ChooseNewBotScreen> createState() => _ChooseNewBotScreenState();
}

class _ChooseNewBotScreenState extends State<ChooseNewBotScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChooseBotCubit>(context).findRandomBot();
  }

  Widget build(BuildContext context) {
    return BlocConsumer<ChooseBotCubit, ChooseBotState>(
      listener: (context, state) {
        if (state is ErrorChoosingBotState) {
          Navigator.of(context).pop();
          CommonWidgets.customSnackBar(context, state.errorMsg);
        } else if (state is ErrorStartingConvoState) {
          Navigator.of(context).pop();
          CommonWidgets.customSnackBar(context, state.errorMsg);
        }
      },
      builder: (context, state) {
        if (state is BotIsReadyToShow) {
          return BotProfileScreen(
            botProfileScreenModel: BotProfileScreenModel(
              schemaBotModel: state.botToShow,
              isChoosingBot: true,
            ),
          );
        } else if (state is StartingConvoWithChoosedBotState) {
          return BotProfileScreen(
              botProfileScreenModel: BotProfileScreenModel(
                  schemaBotModel: state.botToStartConvo,
                  isChoosingBot: true,
                  isLoadingConvo: true));
        } else if (state is BotIsChoosedState) {
          return ChatScreen(bot: state.botToStartConvo);
        }

        return ConversationsLoadingScreen(
            loadingMessage: TextConstants.searchingNewBotForConversation);
      },
      buildWhen: (context, state) {
        return !(state is ErrorStartingConvoState);
      },
    );
  }
}
