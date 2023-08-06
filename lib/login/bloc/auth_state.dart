part of 'auth_bloc.dart';

abstract class AuthState {}

class LoadingState extends AuthState {}

class LoggedOutState extends AuthState {}

class LoggedInState extends AuthState {}
