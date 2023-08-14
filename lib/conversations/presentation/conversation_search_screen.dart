import 'package:chatbot/chat/models/schema_message_model.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/presentation/widgets/conversation_list_tile.dart';
import 'package:chatbot/core/common_ui/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationSearchScreen extends StatefulWidget {
  final List<SchemaBotModel> availableBots;
  const ConversationSearchScreen({super.key, required this.availableBots});

  @override
  State<ConversationSearchScreen> createState() =>
      _ConversationSearchScreenState();
}

class _ConversationSearchScreenState extends State<ConversationSearchScreen> {
  late FocusNode _searchFocusNode;
  TextEditingController _searchController = TextEditingController();

  ValueNotifier<List<SchemaBotModel>> _searchResults =
      ValueNotifier<List<SchemaBotModel>>([]);

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.requestFocus();
    _searchResults.value.addAll(widget.availableBots);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    resetMatchedMessagesOnSearch();
    super.dispose();
  }

  /// FYI: we are reseting matched msg on dispose so that when user comes to search,
  /// they wont see previously searched msg
  void resetMatchedMessagesOnSearch() {
    // Reset the matchedMsgWhileSearching and matchedMsgWhileSearchingTS fields
    for (SchemaBotModel bot in widget.availableBots) {
      bot.matchedMsgWhileSearching = null;
      bot.matchedMsgWhileSearchingTS = null;
    }
  }

  void _performSearch(String query) {
    query = query.toLowerCase();

    _searchResults.value = widget.availableBots.where((bot) {
      final persona = bot.persona;
      final firstNameMatch =
          persona?.firstName?.toLowerCase().contains(query.trim()) ?? false;
      final lastNameMatch =
          persona?.lastName?.toLowerCase().contains(query.trim()) ?? false;

      final fullNameMatch = "${persona?.firstName} ${persona?.lastName}"
          .toLowerCase()
          .contains(query.trim());

      final messages = bot.conversations?.cast<Map<String, dynamic>>() ?? [];

      final messageMatch = messages.any((message) {
        final schemaMessage = SchemaMessageModel.fromJson(message);
        final contentMatch =
            schemaMessage.content?.toLowerCase().contains(query.trim()) ??
                false;
        if (contentMatch) {
          bot.matchedMsgWhileSearching = schemaMessage.content;
          bot.matchedMsgWhileSearchingTS = schemaMessage.createdAt;
        }
        return contentMatch;
      });

      return firstNameMatch || lastNameMatch || fullNameMatch || messageMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: buildAppBarForConversationSearchingScreen(context),
          body: ValueListenableBuilder(
            valueListenable: _searchResults,
            builder: (context, currentlyFoundConversations, child) {
              return ListView.builder(
                  itemCount: currentlyFoundConversations.length,
                  itemBuilder: (context, index) {
                    final SchemaBotModel bot =
                        currentlyFoundConversations[index];
                    return ConversationListTile(bot: bot);
                  });
            },
          )),
    );
  }

  PreferredSize buildAppBarForConversationSearchingScreen(
      BuildContext context) {
    return CommonWidgets.customAppBar(
        context,
        Row(
          children: [
            Expanded(
                child: CupertinoSearchTextField(
              placeholder: "Search by name or message",
              keyboardType: TextInputType.text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer),
              focusNode: _searchFocusNode,
              controller: _searchController,
              onChanged: _performSearch,
            )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 14.sp),
                ))
          ],
        ));
  }
}
