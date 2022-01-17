part of 'get_report_cubit.dart';

abstract class GetReportState extends Equatable {
  const GetReportState();
  @override
  List<Object> get props => [];
}

class GetReportInitial extends GetReportState {}
class GetReportLoading extends GetReportState {}
class GetReportSuccess extends GetReportState {
  final List<UserModel> data;
  final bool hasReachedMax;
  final int limit;

  GetReportSuccess({required this.data,required this.hasReachedMax,required this.limit});

  GetReportSuccess copyWith({List<UserModel>? data,bool? hasReachedMax,int? limit,
  }){
    return GetReportSuccess(
      data: data ?? this.data,hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      limit: limit ?? this.limit
    );
  }

  @override
  List<Object> get props => [data,hasReachedMax,limit];
}
class GetReportFailure extends GetReportState {
  final String msg;

  GetReportFailure(this.msg);
}
