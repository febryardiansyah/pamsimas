import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/ResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ResponseModel> signIn({String? email,String? password})async{
    if (email!.isEmpty && password!.isEmpty) {
      return ResponseModel(status: false,msg: 'Username dan Password tidak boleh kosong',data: null);
    }
    if (email.isEmpty) {
      return ResponseModel(status: false,msg: 'Username tidak boleh kosong',data: null);
    }
    if (password!.isEmpty) {
      return ResponseModel(status: false,msg: 'Password tidak boleh kosong',data: null);
    }

    try{
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(email: '$email@pamdes.com', password: password);
      User _user = _userCredential.user!;

      print(_user.uid);

      return ResponseModel(status: true,msg: 'Berhasil',data: _user.uid);
    }on FirebaseAuthException catch(e){
      print('err : ${e.code} || ${e.message}');
      return ResponseModel(status: false,msg: Helper.getAuthErr(e.code));
    }
  }

  Future<ResponseModel> changePassword({required String email,required String oldPassword,required String newPassword})async{
    try{
      AuthCredential _credential = EmailAuthProvider.credential(email: '$email@pamdes.com', password: oldPassword);
      User? _user = _auth.currentUser;
      await _user?.reauthenticateWithCredential(_credential);
      if (_user != null) {
        print('Current User not null');
        await _user.updatePassword(newPassword);
        String _docId = _user.uid.length > 7 ? _user.uid.substring(0,7):_user.uid;
        _firestore.collection('users').doc(_docId).update({
          'password':newPassword,
        });
      }
      return ResponseModel(
        status: true,msg: 'Password berhasil diubah',data: null,
      );
    }on FirebaseException catch(e){
      return ResponseModel(status: false,msg: Helper.getAuthErr(e.code),data: null);
    }
  }

  Future<void> signOut()async{
    await _auth.signOut();
    await deleteToken();
  }

  Future<void> saveToken(String uid)async{
    final _pref = await SharedPreferences.getInstance();
    _pref.setString(BaseString.token, uid);
  }

  Future<void> deleteToken()async{
    final _pref = await SharedPreferences.getInstance();
    _pref.remove(BaseString.token);
  }

  Future<bool> hasToken()async{
    final _pref = await SharedPreferences.getInstance();
    return _pref.getString(BaseString.token) != null;
  }

  static Future<String> getToken()async{
    final _pref = await SharedPreferences.getInstance();
    return _pref.getString(BaseString.token)!;
  }
}