import 'package:chatbot/conversations/data/models/schema_bot_model.dart';

// to sort bots by last message timestamp (descending order)
List<SchemaBotModel> sortBotsByLatestMessage(List<SchemaBotModel> bots) {
  bots.sort((botA, botB) {
    final String aTimestamp = botA.lastUpdatedMessagesTs ?? "";
    final String bTimestamp = botB.lastUpdatedMessagesTs ?? "";

    if (aTimestamp == "" && bTimestamp == "") {
      return 0; // No timestamps available for comparison
    } else if (aTimestamp == "") {
      return 1; // Put bots without a timestamp at the end
    } else if (bTimestamp == "") {
      return -1; // Put bots without a timestamp at the end
    } else {
      final aDateTime = DateTime.parse(aTimestamp);
      final bDateTime = DateTime.parse(bTimestamp);
      return bDateTime.compareTo(aDateTime); // Sort in descending order
    }
  });

  return bots;
}
