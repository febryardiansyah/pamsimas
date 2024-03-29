import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/ResponseModel.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pamsimas/repositories/auth_repo.dart';

class ProfileRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<ResponseModel?> getMyProfile()async{
    try{
      String _token = await AuthRepo.getToken();
      String _parseToken = _token.length > 7 ? _token.substring(0,7):_token;
      final _res = await _fireStore.collection('users').doc(_parseToken).get();
      print(_res.data());
      return ResponseModel(status: true,msg: 'Success',data: _res.data());
    }on FirebaseException catch(e){
      print('err : ${e.code} || ${e.message}');
      return ResponseModel(status: false,msg: Helper.getAuthErr(e.code),data: null);
    }
  }

  Future<ResponseModel> getHistoryByUid({required int limit,String? uid})async{
    try{
      String _token = await AuthRepo.getToken();
      String _parseToken = _token.length > 7 ? _token.substring(0,7):_token;
      String _uid = uid == null?_parseToken:uid;
      // final _res = await _fireStore
      //     .collection('history').doc(_uid).collection('bills')
      //     .orderBy('createdAt',descending: true)
      //     .limit(limit).get();
      final _res = await _fireStore
          .collection('reports')
          .where('uid',isEqualTo: _uid)
          .orderBy('bill.createdAt',descending: true)
          .limit(limit).get();
      // print(_res.docs);
      return ResponseModel(
          msg: 'Berhasil',data: _res.docs,status: true
      );
    }on FirebaseException catch(e){
      print(e);
      return ResponseModel(
          status: false,data: null,msg: Helper.getAuthErr(e.code)
      );
    }
  }

  Future<ResponseModel> updatePaymentStatus({
    required bool status,required String uid,required bool userCollection,required int totalPaid,String? id,
    required int totalCurrentPaid,int? index,
  })async{
    try{
      print("ID ====> $id");
      print('USER COLLECTION VALUE => $userCollection');
      if (userCollection) {
        print('USER COLLECTION');
        await _fireStore.collection('users').doc(uid).update({
          'bill.isPayed':status,'bill.totalPaid':totalPaid+totalCurrentPaid
        });

      }
      await _fireStore.collection('reports').doc(id).update({
        'bill.isPayed':status,'bill.totalPaid':totalPaid+totalCurrentPaid
      });
      return ResponseModel(
          msg: 'Berhasil memperbaharui status pembayaran',data: null,status: true
      );
    }on FirebaseException catch(e){
      print(e);
      return ResponseModel(
          status: false,data: null,msg: Helper.getAuthErr(e.code)
      );
    }
  }
}