import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pamsimas/bloc/auth/auth_cubit.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/repositories/auth_repo.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
  final _authRepo = AuthRepo();
  final _authCubit = AuthCubit();

  Future<void> signButtonPressed({String? email,String? password})async{
    emit(SignInLoading());
    try{
      final _res = await _authRepo.signIn(email: email,password: password);
      if (_res.status!) {
        await _authCubit.loggedIn(_res.data as String);
        emit(SignInSuccess(msg: _res.msg));
      }else{
        emit(SignInFailure(msg: _res.msg));
      }
    }catch(e){
      print(e);
      emit(SignInFailure(msg: BaseString.errorMessage));
    }
  }
}
