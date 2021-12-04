import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/ResponseModel.dart';
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
}