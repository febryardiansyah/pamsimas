part of 'update_payment_status_cubit.dart';

@immutable
abstract class UpdatePaymentStatusState {}

class UpdatePaymentStatusInitial extends UpdatePaymentStatusState {}
class UpdatePaymentStatusLoading extends UpdatePaymentStatusState {}
class UpdatePaymentStatusSuccess extends UpdatePaymentStatusState {
  final String? msg;

  UpdatePaymentStatusSuccess({this.msg});
}
class UpdatePaymentStatusFailure extends UpdatePaymentStatusState {
  final String? msg;

  UpdatePaymentStatusFailure({this.msg});
}
