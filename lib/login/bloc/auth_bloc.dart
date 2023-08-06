import 'dart:async';
import 'package:chatbot/conversations/cubit/conversationlist_cubit.dart';
import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/core/utils/shared_preferences_helper.dart';
import 'package:chatbot/main_prod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoadingState()) {
    on<AuthCheckerEvent>(_authChecker);
    on<LogoutClickedEvent>(_logoutClick);
  }
  final SharedPrefsHelper prefs = SharedPrefsHelper();

  ///fyi: for checking if user has a loggedin session or not
  /// (useful when app is opened, should navigate to home or login screen based on auth status)
  FutureOr<void> _authChecker(
    AuthCheckerEvent authCheckerEvent,
    Emitter<AuthState> emit,
  ) async {
    emit.call(LoadingState());
    final String? accessToken = await prefs.getAccessToken();

    if (accessToken == null) {
      emit.call(LoggedOutState());
    } else {
      emit.call(LoggedInState());
    }
  }

  ///fyi: when user clicks logout button
  FutureOr<void> _logoutClick(
    LogoutClickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    // clear records of shared pereferences, secure storage and remove firebase auth session
    await locator<FlutterSecureStorage>().deleteAll();
    await prefs.clearAll();
    await locator<FirebaseAuth>().signOut();
    emit.call(LoggedOutState());
    Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil(AppRoutes.onboardingScreen, (route) => false);
    BlocProvider.of<ConversationlistCubit>(navigatorKey.currentContext!)
        .resetToConversationLoadingState();
  }
}
