import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pamsimas/repositories/user_repo.dart';

part 'get_all_user_state.dart';

class GetAllUserCubit extends Cubit<GetAllUserState> {
  GetAllUserCubit() : super(GetAllUserInitial());
  final _repo = UserRepo();

  Future<void> fetchUsers()async{
    emit(GetAllUserLoading());
    try{
      final _res = await _repo.getAllUser();
      if (_res.status!) {
        final _data = List<UserModel>.from(_res.data.map((x)=>UserModel.fromMap(x.data())));
        emit(GetAllUserSuccess(_data));
      } else {
        emit(GetAllUserFailure(_res.msg!));
      }
    }catch(e){
      print(e);
      emit(GetAllUserFailure(BaseString.errorMessage));
    }
  }
}
