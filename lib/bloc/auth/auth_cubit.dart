import 'package:bloc/bloc.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/repositories/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final _repo = AuthRepo();

  Future<void>appStarted()async{
    try{
      final _hasToken = await _repo.hasToken();
      if (_hasToken) {
        emit(AuthAuthenticated());
      }else{
        emit(AuthUnAuthenticated());
      }
    }catch(e){
      print(e);
      emit(AuthUnAuthenticated());
    }
  }

  Future<void>loggedIn(String uid)async{
    try{
      await _repo.saveToken(uid);
      emit(AuthAuthenticated());
    }catch(e){
      print(e);
      emit(AuthUnAuthenticated());
    }
  }

  Future<void>loggedOut()async{
    emit(LogOutLoading());
    try{
      await _repo.deleteToken();
      await _repo.signOut();
      Future.delayed(Duration(seconds: 2));
      emit(LogOutSuccess());
      emit(AuthUnAuthenticated());
    }catch(e){
      print(e);
      emit(LogOutFailure(msg: BaseString.errorMessage));
    }
  }
}
