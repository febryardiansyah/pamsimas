import 'package:bloc/bloc.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/model/profile_model.dart';
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
        emit(GetProfileSuccess(data: ProfileModel.fromMap(_res.data)));
      } else {
        emit(GetProfileFailure(msg: _res.msg!));
      }
    }catch(e){
      print(e);
      emit(GetProfileFailure(msg: BaseString.errorMessage));
    }
  }
}
