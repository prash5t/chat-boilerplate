import 'package:chatbot/core/constants/text_constants.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/conversations/presentation/error_loading_conversation_screen.dart';
import 'package:chatbot/core/common_ui/bool_buttomsheet.dart';
import 'package:chatbot/core/common_ui/custom_splash_screen.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/notifications/app_notifications.dart';
import 'package:chatbot/notifications/firebase_messaging_setup.dart';
import 'package:chatbot/main_prod.dart';
import 'package:chatbot/notifications/update_persona_and_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'conversations_loaded_widget.dart';

class ConversationsListScreen extends StatefulWidget
    with WidgetsBindingObserver {
  const ConversationsListScreen({super.key});

  @override
  State<ConversationsListScreen> createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // first we execute notification related initialization
    // second we load available bots either locally or from network
    // third we sync if user have any followup messsages
    initializeNotificationsRelatedTask().then((_) {
      BlocProvider.of<ConversationlistCubit>(navigatorKey.currentContext!)
          .loadAvailableBots(syncFollowups: syncFollowUps);
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updatePersonaAndMessages(context);
    }
  }

  Future<void> initializeNotificationsRelatedTask() async {
    await requestFCMPermission();
    await AppNotifications.initialize(
        locator<FlutterLocalNotificationsPlugin>());
    await handleForegroundNotification(context);

    /// FYI: below part is of POC of Work Manager. Later it can be used when this feature is neeeded
    /// SO NOT REMOVING BELOW PART
    // initializeWorkManager();
    // int? invokedFrequency =
    //     locator<SharedPreferences>().getInt("invoked_frequency");
    // debugPrint("debug: work manager invoked: $invokedFrequency");
    // CommonWidgets.customSnackBar(
    //     context, "Background worker invoked $invokedFrequency times");
  }

  Future<void> syncFollowUps() async {
    await updatePersonaAndMessages(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? shouldExit = await booleanBottomSheet(
            context: context,
            titleText: TextConstants.closeAppTitle,
            boolTrueText: TextConstants.closeAppText);
        return shouldExit ?? false;
      },
      child: BlocConsumer<ConversationlistCubit, ConversationlistState>(
        listener: (context, state) {
          if (state is ChooseNewBotState) {
            Navigator.of(context).pushNamed(AppRoutes.chooseNewBotScreen);
          }
        },
        builder: (context, state) {
          if (state is ConversationsLoadedState) {
            return ConversationsLoadedWidget(
                availableBots: state.availableBots);
          } else if (state is ErrorState) {
            return ErrorLoadingConversationScreen(
              errorMsg: state.errorMsg,
              isInternetError: state.isInternetError,
            );
          }

          // Conversations Loading State
          return const CustomSplashScreen();
        },
        buildWhen: (previousState, state) {
          // Exclude ChooseNewBotState from triggering a rebuild
          return !(state is ChooseNewBotState);
        },
      ),
    );
  }
}
