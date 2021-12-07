part of 'input_user_bill_cubit.dart';

@immutable
abstract class InputUserBillState {}

class InputUserBillInitial extends InputUserBillState {}
class InputUserBillLoading extends InputUserBillState {}
class InputUserBillSuccess extends InputUserBillState {
  final String? msg;

  InputUserBillSuccess({this.msg});
}
class InputUserBillFailure extends InputUserBillState {
  final String? msg;

  InputUserBillFailure({this.msg});
}
