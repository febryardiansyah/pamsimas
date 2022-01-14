import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/repositories/profile_repo.dart';

part 'update_payment_status_state.dart';

class UpdatePaymentStatusCubit extends Cubit<UpdatePaymentStatusState> {
  UpdatePaymentStatusCubit() : super(UpdatePaymentStatusInitial());
  final _repo = ProfileRepo();

  Future<void> updateStatus({
    required String uid,required bool status,required bool userCollection,required int totalPaid,String? id,
    required int totalCurrentPaid,int? index
  })async{
    emit(UpdatePaymentStatusLoading());
    try{
      final _res = await _repo.updatePaymentStatus(
        status: status, uid: uid,userCollection: userCollection,totalPaid: totalPaid,totalCurrentPaid: totalCurrentPaid,id: id,index: index);
      if (_res.status!) {
        emit(UpdatePaymentStatusSuccess(msg: _res.msg!));
      } else {
        emit(UpdatePaymentStatusFailure(msg: _res.msg!));
      }
    }catch(e){
      print(e);
      emit(UpdatePaymentStatusFailure(msg: BaseString.errorMessage));
    }
  }
}
