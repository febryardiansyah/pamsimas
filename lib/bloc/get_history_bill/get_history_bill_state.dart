part of 'get_history_bill_cubit.dart';

abstract class GetHistoryBillState extends Equatable {
  const GetHistoryBillState();
  @override
  List<Object> get props => [];
}

class GetHistoryBillInitial extends GetHistoryBillState {}
class GetHistoryBillLoading extends GetHistoryBillState {}
class GetHistoryBillSuccess extends GetHistoryBillState {
  final List<BillModel>? data;
  final bool? hasReachedMax;
  final int? limit;

  GetHistoryBillSuccess({this.data, this.hasReachedMax, this.limit});

  GetHistoryBillSuccess copyWith({List<BillModel>? data,bool? hasReachedMax,int? limit,}){
    return GetHistoryBillSuccess(
      data: data ?? this.data,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }

  @override
  List<Object> get props => [data!,hasReachedMax!,limit!];
}
class GetHistoryBillFailure extends GetHistoryBillState {
  final String? msg;

  GetHistoryBillFailure({this.msg});
  @override
  List<Object> get props => [msg!];
}
