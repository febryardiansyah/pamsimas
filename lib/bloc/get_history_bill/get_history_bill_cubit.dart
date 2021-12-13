import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/model/history_model.dart';
import 'package:pamsimas/repositories/profile_repo.dart';

part 'get_history_bill_state.dart';

class GetHistoryBillCubit extends Cubit<GetHistoryBillState> {
  GetHistoryBillCubit() : super(GetHistoryBillInitial());
  final _repo = ProfileRepo();

  Future<void> fetchHistory({String? uid})async{
    emit(GetHistoryBillLoading());
    try{
      int _limit = 10;
      final _res = await _repo.getHistoryByUid(uid: uid,limit: _limit);
      if (_res.status!) {
        final _data = List<BillModel>.from(_res.data.map((x)=>BillModel.fromMap(x.data())));
        emit(GetHistoryBillSuccess(data: _data,limit: _limit+10,hasReachedMax: false));
      } else {
        emit(GetHistoryBillFailure(msg: _res.msg));
      }
    }catch(e){
      print(e);
      emit(GetHistoryBillFailure(msg: BaseString.errorMessage));
    }
  }

  Future<void> onLoading({String? uid})async{
    final _currentState = state;
    if (_currentState is GetHistoryBillSuccess) {
      try{
        int _limit = _currentState.limit!;
        final _res = await _repo.getHistoryByUid(uid: uid,limit: _limit);
        if (_res.status!) {
          final _data = List<BillModel>.from(_res.data.map((x)=>BillModel.fromMap(x.data())));
          print('LENGTH ===> ${_data.length}');
          emit(_data.length == _currentState.data!.length?_currentState.copyWith(data: _currentState.data,hasReachedMax: true,limit: _currentState.limit):
          GetHistoryBillSuccess(data: _data,limit: _limit+10,hasReachedMax: false));
        } else {
          emit(GetHistoryBillFailure(msg: _res.msg));
        }
      }catch(e){
        print(e);
        emit(GetHistoryBillFailure(msg: BaseString.errorMessage));
      }
    }
  }
}
