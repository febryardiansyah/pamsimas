import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/repositories/auth_repo.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());
  final _repo = AuthRepo();

  Future<void> changePass({required String email,required String oldPassword,required String newPassword})async{
    emit(ChangePasswordLoading());
    try{
      final _res = await _repo.changePassword(email: email,oldPassword: oldPassword,newPassword: newPassword);
      if (_res.status!) {
        emit(ChangePasswordSuccess(msg: _res.msg));
      }else{
        emit(ChangePasswordFailure(msg: _res.msg));
      }
    }catch(e){
      print(e);
      emit(ChangePasswordFailure(msg: BaseString.errorMessage));
    }
  }
}
