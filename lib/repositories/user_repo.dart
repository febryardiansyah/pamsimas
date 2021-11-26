import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/ResponseModel.dart';

class UserRepo{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<ResponseModel> getUserByUid(String uid)async{
    try{
      final _res = await _fireStore.collection('users').doc(uid).get();
      print(_res.data());
      if (_res.data() == null) {
        return ResponseModel(
          status: false,msg: 'Pengguna tidak ditemukan',data: null,
        );
      }
      return ResponseModel(status: true,msg: 'success',data: _res.data());
    }on FirebaseException catch(e){
      return ResponseModel(
        status: false,msg: Helper.getAuthErr(e.code),data: null,
      );
    }
  }
}