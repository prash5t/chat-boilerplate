part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthCheckerEvent extends AuthEvent {}

class LogoutClickedEvent extends AuthEvent {}
