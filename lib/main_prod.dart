import 'package:chatbot/chat/cubit/chat_cubit.dart';
import 'package:chatbot/conversations/cubit/choose_bot_cubit.dart';
import 'package:chatbot/core/constants/network_constants.dart';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/conversations/cubit/delete_conversation_cubit.dart';
import 'package:chatbot/core/internet_connectivity_cubit/internet_connectivity_cubit.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/routes/route_generator.dart';
import 'package:chatbot/core/utils/analytics/analytics_keys.dart';
import 'package:chatbot/login/cubit/authbutton_cubit.dart';
import 'package:chatbot/login/cubit/otp_cubit.dart';
import 'package:chatbot/menu/bloc/cubit/acc_delete_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/themes/theme_cubit/cubit/theme_cubit.dart';
import 'core/firebase/firebase_setup.dart';
import 'core/utils/service_locator.dart';
import 'login/bloc/auth_bloc.dart';
import 'notifications/top_level_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup("Boilerplate").initializeFirebase();
  NetworkConstants.baseUrl = NetworkConstants.prodBaseUrl;
  AnalyticsKeys.mixPanelToken = AnalyticsKeys.mixPanelProdToken;
  await setUpLocator();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
  await SentryFlutter.init(
    (options) {
      options.dsn = 'KEEP_UR_URL_HERE';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp(
      title: "Boilerplate",
    )),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final String title;
  const MyApp({
    super.key,
    required this.title,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (BuildContext context) =>
                AuthBloc()..add(AuthCheckerEvent())),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => ConversationlistCubit(locator()),
        ),
        BlocProvider(
          create: (context) => ChatCubit(locator()),
        ),
        BlocProvider(
          create: (context) => AuthButtonCubit(),
        ),
        BlocProvider(
          create: (context) => DeleteConversationCubit(),
        ),
        BlocProvider(
          create: (context) => OTPCubit(locator()),
        ),
        BlocProvider(
          create: (context) => ChooseBotCubit(),
        ),
        BlocProvider(create: (context) => AccDeleteCubit()),
        BlocProvider(
            create: (context) =>
                InternetConnectivityCubit(locator<InternetConnectionChecker>()))
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, themeToUse) {
              BlocProvider.of<ThemeCubit>(context).getTheme();
              return MaterialApp(
                navigatorObservers: [
                  FirebaseAnalyticsObserver(
                      analytics: locator<FirebaseAnalytics>())
                ],
                title: title,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                onGenerateRoute: onGenerateRoute,
                initialRoute: AppRoutes.authCheckerScreen,
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
                theme: themeToUse,
              );
            },
          );
        },
      ),
    );
  }
}
