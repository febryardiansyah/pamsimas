part of 'change_password_cubit.dart';

@immutable
abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}
class ChangePasswordLoading extends ChangePasswordState {}
class ChangePasswordSuccess extends ChangePasswordState {
  final String? msg;

  ChangePasswordSuccess({this.msg});
}
class ChangePasswordFailure extends ChangePasswordState {
  final String? msg;

  ChangePasswordFailure({this.msg});
}
