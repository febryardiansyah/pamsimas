part of 'get_data_cubit.dart';

abstract class GetDataState extends Equatable {
  const GetDataState();
  @override
  List<Object> get props => [];
}

class GetDataInitial extends GetDataState {}
class GetDataLoading extends GetDataState {}
class GetDataSuccess extends GetDataState {
  final List<UserModel>? data;
  final bool? hasReachedMax;
  final int? limit;

  GetDataSuccess({this.data, this.hasReachedMax, this.limit});

  GetDataSuccess copyWith({List<UserModel>? data,bool? hasReachedMax,int? limit,}){
    return GetDataSuccess(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      limit: limit ?? this.limit
    );
  }

  @override
  List<Object> get props => [data!,hasReachedMax!,limit!];
}
class GetDataFailure extends GetDataState {
  final String? msg;

  GetDataFailure({this.msg});

  @override
  List<Object> get props => [msg!];
}
