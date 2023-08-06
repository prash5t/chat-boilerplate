part of 'chat_cubit.dart';

abstract class ChatState {
  const ChatState();
}

class ChatLoadingState extends ChatState {
  String? chatBotId;
  ChatLoadingState({this.chatBotId});
}

class ChatLoadedState extends ChatState {
  List<ChatMessage> conversationHistory;
  String chatBotId;
  ChatLoadedState({required this.conversationHistory, required this.chatBotId});
}

class BotTypingState extends ChatState {
  List<ChatMessage> conversationHistory;
  List<ChatUser> typingUsers;
  String chatBotId;
  BotTypingState(
      {required this.conversationHistory,
      required this.typingUsers,
      required this.chatBotId});
}

class ErrorState extends ChatState {}
