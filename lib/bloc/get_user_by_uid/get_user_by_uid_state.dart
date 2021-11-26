part of 'get_user_by_uid_cubit.dart';

abstract class GetUserByUidState {}

class GetUserByUidInitial extends GetUserByUidState {}
class GetUserByUidLoading extends GetUserByUidState {}
class GetUserByUidSuccess extends GetUserByUidState {
  final UserModel? data;

  GetUserByUidSuccess({this.data});
}
class GetUserByUidFailure extends GetUserByUidState {
  final String? msg;

  GetUserByUidFailure({this.msg});
}
