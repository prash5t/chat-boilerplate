import 'package:chatbot/core/routes/app_routes.dart';
import 'package:chatbot/login/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCheckerScreen extends StatelessWidget {
  const AuthCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoggedInState) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.conversationsListScreen, (route) => false);
          } else if (state is LoggedOutState) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.onboardingScreen, (route) => false);
          }
        },
        child: const Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
