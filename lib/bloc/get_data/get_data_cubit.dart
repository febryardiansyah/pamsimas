import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pamsimas/repositories/user_repo.dart';

part 'get_data_state.dart';

class GetDataCubit extends Cubit<GetDataState> {
  GetDataCubit() : super(GetDataInitial());
  final _repo = UserRepo();

  Future<void> fetchData({String? query,bool? status,String? category,String? role})async{
    emit(GetDataLoading());
    try{
      final _limit = 10;
      final _res = await _repo.searchUser(limit: _limit,query: query,status: status,category: category,role: role);
      if (_res.status!) {
        final _data = List<UserModel>.from(_res.data.map((x)=>UserModel.fromMap(x.data())));
        emit(GetDataSuccess(data: _data,limit: _limit+10,hasReachedMax: false));
      } else {
        emit(GetDataFailure(msg: _res.msg));
      }
    }catch(e){
      print(e);
      emit(GetDataFailure(msg: BaseString.errorMessage));
    }
  }

  Future<void> onLoading({String? query,bool? status,String? category,String? role})async{
    final _currentState = state;
    if (_currentState is GetDataSuccess) {
      try{
        final _limit = _currentState.limit!;
        final _res = await _repo.searchUser(limit: _limit,query: query,status: status,category: category,role: role);
        if (_res.status!) {
          final _data = List<UserModel>.from(_res.data.map((x)=>UserModel.fromMap(x.data())));
          print('LENGTH =====> ${_data.length}');
          emit(_data.length == _currentState.data!.length?_currentState.copyWith(
            data: _currentState.data,hasReachedMax: true,limit: _currentState.limit
          ):
          GetDataSuccess(data: _data,limit: _limit+10,hasReachedMax: false));
        } else {
          emit(GetDataFailure(msg: _res.msg));
        }
      }catch(e){
        print(e);
        emit(GetDataFailure(msg: BaseString.errorMessage));
      }
    }
  }
}
