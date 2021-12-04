import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/repositories/user_repo.dart';

part 'create_user_state.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  CreateUserCubit() : super(CreateUserInitial());
  final _repo = UserRepo();

  Future<void> createUser({String? name,String? address,String? role,String? category})async{
    emit(CreateUserLoading());
    try{
      final _res = await _repo.createNewUser(name: name,role: role,category: category,address: address);
      if (_res.status!) {
        emit(CreateUserSuccess(msg: _res.msg));
      }else{
        emit(CreateUserFailure(msg: _res.msg));
      }
    }catch(e){
      print(e);
      emit(CreateUserFailure(msg: BaseString.errorMessage));
    }
  }
}
