import 'package:chatbot/conversations/data/models/schema_bot_model.dart';

class BotProfileScreenModel {
  final SchemaBotModel schemaBotModel;
  final bool isChoosingBot;
  final bool? isLoadingConvo;

  BotProfileScreenModel({
    required this.schemaBotModel,
    required this.isChoosingBot,
    this.isLoadingConvo,
  });
}
