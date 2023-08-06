import 'package:chatbot/bot_profile/model/botprofilescreen_model.dart';
import 'package:chatbot/chat/presentation/online_status_widget.dart';
import 'package:chatbot/conversations/cubit/choose_bot_cubit.dart';
import 'package:chatbot/conversations/data/models/persona_model.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/core/common_ui/cached_image_widget.dart';
import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/common_ui/sizedbox_height50.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/utils/limit_text_by_length.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_tags/simple_tags.dart';
import 'bot_profile_appbar.dart';

class BotProfileScreen extends StatefulWidget {
  final BotProfileScreenModel botProfileScreenModel;
  const BotProfileScreen({super.key, required this.botProfileScreenModel});

  @override
  State<BotProfileScreen> createState() => _BotProfileScreenState();
}

class _BotProfileScreenState extends State<BotProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final SchemaBotModel bot = widget.botProfileScreenModel.schemaBotModel;
    final PersonaModel? persona = bot.persona;
    final String imageUrl = persona?.image ?? ImagePaths.defaultNetworkImage;
    // final bool isOnline = persona?.isAvailable ?? false;
    final String status = persona?.status ?? PersonaModel.kKeyInactive;
    final bool isChoosingBot = widget.botProfileScreenModel.isChoosingBot;
    // final List<String> hobbies = persona?.hobbies ?? [];
    final List<String> hobbies = persona?.hobbies
            ?.map((hobby) =>
                returnTextOfThisLength(text: hobby.toUpperCase(), length: 20))
            .toList() ??
        [];

    final bool loadingConvo =
        widget.botProfileScreenModel.isLoadingConvo ?? false;
    // final List<dynamic> hobbies = [
    //   'Cycling',
    //   'Running',
    //   'Travelling',
    //   "Reading",
    //   'Cooking',
    // ];
    final String fullName = returnTextOfThisLength(
        text: "${bot.persona?.firstName} ${bot.persona?.lastName}", length: 15);
    return Scaffold(
      appBar: buildBotProfileAppBar(context),
      floatingActionButton: !isChoosingBot
          ? null
          : Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBoxHeight50(
                      widget: ElevatedButton(
                          onPressed: () {
                            if (!loadingConvo) {
                              BlocProvider.of<ChooseBotCubit>(context)
                                  .startConversationWithThisBot(
                                      choosedBot: bot);
                            }
                          },
                          child: loadingConvo
                              ? SizedBox(
                                  height: 16.h,
                                  width: 16.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(Icons.check))),
                  SizedBox(width: 8.w),
                  SizedBoxHeight50(
                      widget: ElevatedButton(
                          onPressed: () {
                            if (!loadingConvo) {
                              BlocProvider.of<ChooseBotCubit>(context)
                                  .findRandomBot();
                            }
                          },
                          child: Icon(Icons.restart_alt)))
                ],
              ),
            ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Container(
                  width: double.infinity,
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [BoxShadow(blurRadius: 15.0)],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: CachedImageWidget(imageUrl: imageUrl)),
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: status == PersonaModel.kKeyNotificationOff
                                  ? 8.h
                                  : 0),
                          child: AvailabilityIconWidget(
                              status: status, widthHeight: 18),
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: "$fullName, ${persona?.age}",
                          textColor: Theme.of(context).primaryColor,
                          isBold: true,
                          size: 30.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 25.w),
                    //   child: CustomText(
                    //     text: returnTextOfThisLength(
                    //         text: bot.persona?.description ?? "", length: 80),
                    //     alignCenter: true,
                    //   ),
                    // )
                  ],
                ),
                SizedBox(height: 15.h),
                BotBasicInfo(persona: bot.persona),
                SizedBox(height: 20.h),
                if (hobbies.isNotEmpty)
                  CustomText(
                    text: "Hobbies",
                    size: 18.sp,
                    isBold: true,
                    textColor: Theme.of(context).primaryColor,
                  ),
                SizedBox(height: 10.h),
                SimpleTags(
                  content: hobbies,
                  wrapSpacing: 8,
                  wrapRunSpacing: 8,
                  tagTextStyle: TextStyle(
                    fontSize: 12.sp,
                  ),
                  tagContainerPadding: EdgeInsets.all(8),
                  tagContainerDecoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Color.fromRGBO(139, 139, 142, 0.16),
                    //     spreadRadius: 1,
                    //     blurRadius: 1,
                    //     offset: Offset(1.75, 3.5), // c
                    //   )
                    // ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BotBasicInfo extends StatelessWidget {
  final PersonaModel? persona;
  const BotBasicInfo({
    super.key,
    required this.persona,
  });

  @override
  Widget build(BuildContext context) {
    final String livesIn = "${persona?.city}, ${persona?.country}";
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.home, size: 20.sp),
            SizedBox(width: 7.w),
            CustomText(
              text: "Lives in",
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            CustomText(text: livesIn, size: 16.sp)
          ],
        ),
        // SizedBox(height: 4.h),
        // Row(
        //   children: [
        //     Icon(Icons.school, size: 22.sp),
        //     SizedBox(width: 7.w),
        //     CustomText(
        //       text: "Timezone:",
        //       size: 16.sp,
        //     ),
        //     SizedBox(width: 4.w),
        //     CustomText(text: persona!.timezone ?? "", size: 16.sp)
        //   ],
        // )
      ],
    );
  }
}
