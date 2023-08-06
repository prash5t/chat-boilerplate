part of 'conversationlist_cubit.dart';

abstract class ConversationlistState {}

class ConversationsLoadingState extends ConversationlistState {}

class ConversationsLoadedState extends ConversationlistState {
  List<SchemaBotModel> availableBots;
  ConversationsLoadedState({required this.availableBots});
}

class ErrorState extends ConversationlistState {
  String? errorMsg;
  bool isInternetError;
  ErrorState({this.errorMsg, required this.isInternetError});
}

class ChooseNewBotState extends ConversationlistState {}
