import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pamsimas/repositories/user_repo.dart';

part 'input_user_bill_state.dart';

class InputUserBillCubit extends Cubit<InputUserBillState> {
  InputUserBillCubit() : super(InputUserBillInitial());
  final _repo = UserRepo();

  Future<void> inputBill({
    required String uid,required int currentBill,required String month,required String year,required int currentUsage,int? lastBill,int? lastUsage,
    required UserModel userData,
  })async{
    emit(InputUserBillLoading());
    try{
      final _res = await _repo.inputUserBill(uid: uid, currentBill: currentBill, month: month,year: year,currentUsage: currentUsage,lastBill: lastBill,
      lastUsage: lastUsage,userData: userData);
      if (_res.status!) {
        emit(InputUserBillSuccess(msg: _res.msg));
      } else {
        emit(InputUserBillFailure(msg: _res.msg));
      }
    }catch(e){
      print(e);
      emit(InputUserBillFailure(msg: BaseString.errorMessage));
    }
  }
}
