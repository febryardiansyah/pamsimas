import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/ResponseModel.dart';
import 'package:pamsimas/model/history_model.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:uuid/uuid.dart';

class UserRepo{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _uuid = Uuid();

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
      UserCredential _user = await _auth.createUserWithEmailAndPassword(email: '$_email@pamdes.com', password: '123456',);
      String _uid = _user.user!.uid.substring(0,7);
      await _fireStore.collection('users').doc(_uid).set({
        'name':name,'address':address,'password':'123456','role':role,'category':category,
        'uid':_uid,'username':_email,'email': '$_email@pamdes.com',
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

  Future<ResponseModel> inputUserBill({
    required String uid,required int currentBill,required String month,required String year,required int currentUsage,
    int? lastBill,int? lastUsage,required UserModel userData,
  })async{
    try{
      bool _isExist = await _checkDateExist(uid, month, year);
      print('IS Exist ==> $_isExist');
      if (_isExist) {
        return ResponseModel(
          status: false,msg: 'Data tanggal ini sudah ada',data: null,
        );
      }
      String _id = '${_uuid.v1()}$uid${DateTime.now().millisecondsSinceEpoch}';
      await _fireStore.collection('users').doc(uid).update({
        'bill':{
          'currentBill':currentBill,'month':month,'isPayed':false,'year':year,'currentUsage':currentUsage,'createdAt':DateTime.now(),'id':_id,
          'totalPaid':0,'lastBill':lastBill ?? 0,'lastUsage':lastUsage??0
        }
      });
      print('BILL DOC ID ==> $_id');
      final _billData = BillModel(
        currentBill: currentBill,month: month,isPayed: false,year: year,currentUsage: currentUsage,createdAt: DateTime.now(),id:_id,
        totalPaid: 0,lastBill: lastBill ?? 0,lastUsage: lastUsage ?? 0,
      );

      final _userData = UserModel(
        name: userData.name,address: userData.address,bill: _billData,
        category: userData.category,uid: userData.uid,role: userData.role
      );

      await _fireStore.collection('reports').doc(_id).set(_userData.toMap());

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

  Future<bool> _checkDateExist(String uid,String month,String year)async{
    final _res = await _fireStore.collection('reports')
        .where('uid',isEqualTo: uid)
        .where('bill.month',isEqualTo: month)
        .where('bill.year',isEqualTo: year)
        .get();
    return _res.docs.isNotEmpty;
  }

  Future<ResponseModel> searchUser({required int limit,String? query,bool? status,String? category})async{
    try{
      String _query = query == null?'':query.length == 0?'':query[0].toUpperCase()+query.substring(1).toLowerCase();
      print(_query);
      final _res = await _fireStore.collection('users')
          .limit(limit)
          .where('name',isGreaterThanOrEqualTo: _query)
          .where('bill.isPayed',isEqualTo: status)
          .where('category',isEqualTo: category)
          .get();
      // print(_res.docs[0].data());
      return ResponseModel(
        msg: 'Pencarian berhasil',data: _res.docs,status: true
      );
    }on FirebaseException catch(e){
      print(e);
      return ResponseModel(
        status: false,data: null,msg: Helper.getAuthErr(e.code)
      );
    }
  }

  Future<ResponseModel> getAllUser()async{
    try{
      final _res = await _fireStore.collection('users').
          where('role',isEqualTo: 'Pelanggan')
          .get();
      return ResponseModel(
          msg: 'Pencarian berhasil',data: _res.docs,status: true
      );
    }on FirebaseException catch(e){
      print(e);
      return ResponseModel(
          status: false,data: null,msg: Helper.getAuthErr(e.code)
      );
    }
  }


  static Future<List<String>> getAddress({required String address})async{
    final _res = await FirebaseFirestore.instance.collection('address').doc(address).get();
    List<String>_data = List<String>.from(_res.data()!['value'].map((x)=>x));
    print('ADDRESS $_data');
    return _data;
  }

  Future<ResponseModel> getReport({required String month,required String year,required String rt,required String rw,required int limit})async{
    try{
      final _res = await _fireStore.collection('reports')
          .where('bill.month',isEqualTo: month)
          .where('bill.year',isEqualTo: year)
          .where('address',isEqualTo: 'RT.$rt / RW.$rw')
          .get();
      print(_res.docs);
      return ResponseModel(
          msg: 'Data ditemukan',data: _res.docs,status: true
      );
    }on FirebaseException catch(e){
      print(e);
      return ResponseModel(
          status: false,data: null,msg: Helper.getAuthErr(e.code)
      );
    }
  }
}