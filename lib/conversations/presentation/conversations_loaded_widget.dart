import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/presentation/widgets/conversation_list_tile.dart';
import 'package:chatbot/conversations/presentation/widgets/conversations_screen_appbar.dart';
import 'package:chatbot/conversations/presentation/widgets/no_conversations_yet_widget.dart';
import 'package:chatbot/conversations/presentation/widgets/search_conversation_widget.dart';
import 'package:chatbot/core/utils/analytics/analytics_functions.dart';
import 'package:chatbot/core/utils/analytics/analytics_keys.dart';
import 'package:chatbot/core/utils/sort_bots_by_timestamp.dart';
import 'package:flutter/material.dart';

class ConversationsLoadedWidget extends StatefulWidget {
  final List<SchemaBotModel> availableBots;
  const ConversationsLoadedWidget({super.key, required this.availableBots});

  @override
  State<ConversationsLoadedWidget> createState() =>
      _ConversationsLoadedWidgetState();
}

class _ConversationsLoadedWidgetState extends State<ConversationsLoadedWidget> {
  @override
  void initState() {
    super.initState();
    setUserPropertiesInAnalytics(
        AnalyticsKeys.kKeyNumOfBots, widget.availableBots.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: conversationsScreenAppBar(context),
      body: (widget.availableBots.isEmpty)
          ? const NoConversationsYet()
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// FYI: only show conversation searching widget if there are more than 7 conversations
                  if (widget.availableBots.length > 7)
                    SearchConversationWidget(
                      availableBots: widget.availableBots,
                    ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.availableBots.length,
                      itemBuilder: (context, index) {
                        List<SchemaBotModel> sortedBots =
                            sortBotsByLatestMessage(widget.availableBots);
                        return ConversationListTile(bot: sortedBots[index]);
                      }),
                ],
              ),
            ),
    );
  }
}
