import 'package:bloc/bloc.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pamsimas/repositories/user_repo.dart';

part 'get_user_by_uid_state.dart';

class GetUserByUidCubit extends Cubit<GetUserByUidState> {
  GetUserByUidCubit() : super(GetUserByUidInitial());
  final _repo = UserRepo();

  Future<void> fetchUserByUid(String uid)async{
    emit(GetUserByUidLoading());
    try{
      final _res = await _repo.getUserByUid(uid);
      if (_res.status!) {
        final _data = UserModel.fromMap(_res.data);
        emit(GetUserByUidSuccess(data: _data));
      } else {
        emit(GetUserByUidFailure(msg: _res.msg));
      }
    }catch(e){
      print(e);
      emit(GetUserByUidFailure(msg: BaseString.errorMessage));
    }
  }
}
