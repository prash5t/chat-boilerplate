part of 'choose_bot_cubit.dart';

abstract class ChooseBotState {}

class ChoosingBotState extends ChooseBotState {}

class BotIsReadyToShow extends ChooseBotState {
  final SchemaBotModel botToShow;

  BotIsReadyToShow({required this.botToShow});
}

class ErrorChoosingBotState extends ChooseBotState {
  final String errorMsg;

  ErrorChoosingBotState({required this.errorMsg});
}

class ErrorStartingConvoState extends ChooseBotState {
  final String errorMsg;

  ErrorStartingConvoState({required this.errorMsg});
}

class StartingConvoWithChoosedBotState extends ChooseBotState {
  final SchemaBotModel botToStartConvo;

  StartingConvoWithChoosedBotState({required this.botToStartConvo});
}

class BotIsChoosedState extends ChooseBotState {
  final SchemaBotModel botToStartConvo;

  BotIsChoosedState({required this.botToStartConvo});
}
