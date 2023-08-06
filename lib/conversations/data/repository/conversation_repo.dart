import 'package:chatbot/chat/models/schema_message_model.dart';
import 'package:chatbot/conversations/data/models/created_chatbot_model.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/data/models/user_profile_model.dart';
import 'package:chatbot/core/network/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class ConversationRepo {
  Future<Either<UserProfileModel, Failure>> getProfileAndBots();
  Future<Either<SchemaBotModel, Failure>> searchNewBot();
  Future<Either<CreatedBotModel, Failure>> createNewConversation(
      {String? choosedBotId});
  Future<Either<void, Failure>> deleteThisBot(String botId);
  Future<Either<SchemaMessageModel, Failure>> getNewMessage(
      List<dynamic> ongoingConversation, String botId);
  Future<Either<void, Failure>> notifyFollowUpsAreSynced(String chatBotId);
}
