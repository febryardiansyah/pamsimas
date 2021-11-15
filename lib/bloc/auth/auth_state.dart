part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthUnAuthenticated extends AuthState {}
