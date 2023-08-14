import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///FYI: below is the static search widget used on conversation list screen

class SearchConversationWidget extends StatelessWidget {
  final List<SchemaBotModel> availableBots;
  const SearchConversationWidget({super.key, required this.availableBots});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                  AppRoutes.conversationSearchScreen,
                  arguments: availableBots);
            },
            child: SizedBox(
              height: 32.h,
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    prefixIcon: Icon(CupertinoIcons.search),
                    enabled: false,
                    fillColor: CupertinoColors.tertiarySystemFill,
                    filled: true),
              ),
            )));
  }
}
