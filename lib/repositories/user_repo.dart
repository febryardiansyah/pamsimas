import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/ResponseModel.dart';
import 'package:pamsimas/model/history_model.dart';

class UserRepo{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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

  Future<ResponseModel> createNewUser({String? name,String? address,String? role,String? category})async{
    try{
      String _email = name!.replaceAll(' ', '').toLowerCase();
      UserCredential _user = await _auth.createUserWithEmailAndPassword(email: '$_email@pampay.com', password: '123456',);
      String _uid = _user.user!.uid.substring(0,7);
      await _fireStore.collection('users').doc(_uid).set({
        'name':name,'address':address,'password':'123456','role':role,'category':category,
        'uid':_uid
      });
      return ResponseModel(
        status: true,msg: 'Berhasil ditambahkan',
        data: null
      );
    }on FirebaseException catch(e){
      print(e);
      return ResponseModel(
        status: false,msg: Helper.getAuthErr(e.code),data: null
      );
    }
  }

  Future<ResponseModel> inputUserBill({required String uid,required int currentBill,required String month,required String year,required String usage})async{
    try{
      final _billData = BillModel(
          currentBill: currentBill,month: month,isPayed: false,year: year,usage: usage
      );
      await _fireStore.collection('users').doc(uid).update({
        'bill':{
          'currentBill':currentBill,'month':month,'isPayed':false,'year':year,'usage':usage
        }
      });
      final _ref = _fireStore.collection('history').doc(uid);
      _ref.get().then((value)async{
        if (value.data() == null) {
          await _fireStore.collection('history').doc(uid).set({
            'uid':uid,
            'bills':FieldValue.arrayUnion([_billData.toMap()]),
          });
        } else {
          List _list = await value.data()!['bills'];
          _list.add(_billData.toMap());
          await _fireStore.collection('history').doc(uid).set({
            'uid':uid,
            'bills':FieldValue.arrayUnion(_list),
          });
        }
      });

      return ResponseModel(
        status: true,msg: 'Berhasil',data: null,
      );
    }on FirebaseException catch(e){
      print(e);
      return ResponseModel(
        status: false,msg: Helper.getAuthErr(e.code),data: null
      );
    }
  }

  Future<bool> _checkName(String name)async{
    final _res = await _fireStore.collection('users').where('name',isEqualTo: name).get();
    return _res.docs.isNotEmpty;
  }
}