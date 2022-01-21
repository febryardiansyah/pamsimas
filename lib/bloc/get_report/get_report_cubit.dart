import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pamsimas/repositories/user_repo.dart';

part 'get_report_state.dart';

class GetReportCubit extends Cubit<GetReportState> {
  GetReportCubit() : super(GetReportInitial());
  final _repo = UserRepo();

  Future<void> fetchReport({required String month,required String year,required String rt,required String rw})async{
    emit(GetReportLoading());
    try{
      final _limit = 10;
      final _res = await _repo.getReport(month: month, year: year, rt: rt, rw: rw, limit: _limit);
      if (_res.status!) {
        final _data = List<UserModel>.from(_res.data.map((x)=>UserModel.fromMap(x.data())));
        emit(GetReportSuccess(data: _data,limit: _limit+10,hasReachedMax: false));
      } else {
        emit(GetReportFailure(_res.msg!));
      }
    }catch(e){
      print(e);
      emit(GetReportFailure(BaseString.errorMessage));
    }
  }

  Future<void> onLoading({required String month,required String year,required String rt,required String rw})async{
    final _currentState = state;
    if (_currentState is GetReportSuccess) {
      try{
        final _limit = _currentState.limit;
        final _res = await _repo.getReport(month: month, year: year, rt: rt, rw: rw, limit: _limit);
        if (_res.status!) {
          final _data = List<UserModel>.from(_res.data.map((x)=>UserModel.fromMap(x.data())));
          emit(_data.length == _currentState.data.length?_currentState.copyWith(
              data: _currentState.data,hasReachedMax: true,limit: _currentState.limit
          ):
          GetReportSuccess(data: _data,limit: _limit+10,hasReachedMax: false));
        } else {
          emit(GetReportFailure(_res.msg!));
        }
      }catch(e){
        print(e);
        emit(GetReportFailure(BaseString.errorMessage));
      }
    }
  }

  Future<void> clear()async{
    emit(GetReportInitial());
  }
}
