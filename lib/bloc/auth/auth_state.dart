part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthUnAuthenticated extends AuthState {}
class LogOutLoading extends AuthState {}
class LogOutSuccess extends AuthState {}
class LogOutFailure extends AuthState {
  final String? msg;

  LogOutFailure({this.msg});
}
