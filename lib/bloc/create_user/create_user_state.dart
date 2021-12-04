part of 'create_user_cubit.dart';

@immutable
abstract class CreateUserState {}

class CreateUserInitial extends CreateUserState {}
class CreateUserLoading extends CreateUserState {}
class CreateUserSuccess extends CreateUserState {
  final String? msg;

  CreateUserSuccess({this.msg});
}
class CreateUserFailure extends CreateUserState {
  final String? msg;

  CreateUserFailure({this.msg});
}
