import 'package:bloc/bloc.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pamsimas/repositories/profile_repo.dart';

part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  GetProfileCubit() : super(GetProfileInitial());
  final _repo = ProfileRepo();

  Future<void> fetchProfile()async{
    emit(GetProfileLoading());
    try{
      final _res = await _repo.getMyProfile();
      if (_res!.status!) {
        emit(GetProfileSuccess(data: UserModel.fromMap(_res.data)));
      } else {
        emit(GetProfileFailure(msg: _res.msg!));
      }
    }catch(e){
      print('Fetch profile failure: $e');
      emit(GetProfileFailure(msg: BaseString.errorMessage));
    }
  }
}
