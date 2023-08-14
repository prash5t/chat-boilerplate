import 'package:chatbot/core/constants/text_constants.dart';
import 'package:flutter/material.dart';

class NoConversationsYet extends StatelessWidget {
  const NoConversationsYet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(TextConstants.noConversationYet),
    );
  }
}
