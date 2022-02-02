part of 'get_all_user_cubit.dart';

@immutable
abstract class GetAllUserState {}

class GetAllUserInitial extends GetAllUserState {}
class GetAllUserLoading extends GetAllUserState {}
class GetAllUserSuccess extends GetAllUserState {
  final List<UserModel> users;

  GetAllUserSuccess(this.users);
}
class GetAllUserFailure extends GetAllUserState {
  final String msg;

  GetAllUserFailure(this.msg);
}
