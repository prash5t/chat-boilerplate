import 'package:chatbot/bot_profile/model/botprofilescreen_model.dart';
import 'package:chatbot/bot_profile/presentation/bot_profile_screen.dart';
import 'package:chatbot/chat/presentation/chat_screen.dart';
import 'package:chatbot/conversations/data/models/schema_bot_model.dart';
import 'package:chatbot/conversations/presentation/choose_new_bot_screen.dart';
import 'package:chatbot/conversations/presentation/conversation_search_screen.dart';
import 'package:chatbot/conversations/presentation/conversationslist_screen.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/login/presentation/auth_checker_screen.dart';
import 'package:chatbot/login/presentation/onboarding_screen.dart';
import 'package:chatbot/login/presentation/otp_verification_screen.dart';
import 'package:chatbot/login/presentation/select_country_screen.dart';
import 'package:chatbot/login/presentation/signin_with_phonenumber_screen.dart';
import 'package:chatbot/menu/presentation/menu_screen.dart';
import 'package:flutter/cupertino.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  Object? argument = settings.arguments;
  switch (settings.name) {
    case AppRoutes.authCheckerScreen:
      return CupertinoPageRoute(
          builder: (context) => const AuthCheckerScreen());
    case AppRoutes.onboardingScreen:
      return CupertinoPageRoute(builder: (context) => const OnboardingScreen());
    case AppRoutes.selectCountryScreen:
      return CupertinoPageRoute(
          builder: (context) => const SelectCountryScreen());
    case AppRoutes.phoneNumberScreen:
      return CupertinoPageRoute(
          builder: (context) => const SignInWithPhoneNumberScreen());
    case AppRoutes.otpScreen:
      return CupertinoPageRoute(
          builder: (context) =>
              OTPVerificationScreen(number: argument as String));
    case AppRoutes.conversationsListScreen:
      return CupertinoPageRoute(
          builder: (context) => const ConversationsListScreen());
    case AppRoutes.chatScreen:
      return CupertinoPageRoute(
          builder: (context) => ChatScreen(
                bot: argument as SchemaBotModel,
              ));
    case AppRoutes.chooseNewBotScreen:
      return CupertinoPageRoute(builder: (context) => ChooseNewBotScreen());
    case AppRoutes.botProfileScreen:
      return CupertinoPageRoute(
          builder: (context) => BotProfileScreen(
                botProfileScreenModel: argument as BotProfileScreenModel,
              ));
    case AppRoutes.menuScreen:
      return pageRouteBuilder(screen: MenuScreen());
    case AppRoutes.conversationSearchScreen:
      return CupertinoModalPopupRoute(
          builder: (context) => ConversationSearchScreen(
                availableBots: argument as List<SchemaBotModel>,
              ));
    default:
      return CupertinoPageRoute(builder: (context) => const OnboardingScreen());
  }
}

pageRouteBuilder({required Widget screen}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1.0, 0.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
