part of 'get_profile_cubit.dart';

abstract class GetProfileState {}

class GetProfileInitial extends GetProfileState {}
class GetProfileLoading extends GetProfileState {}
class GetProfileSuccess extends GetProfileState {
  final ProfileModel? data;

  GetProfileSuccess({this.data});
}
class GetProfileFailure extends GetProfileState {
  final String? msg;

  GetProfileFailure({this.msg});
}
