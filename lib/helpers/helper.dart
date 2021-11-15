import 'package:flutter/cupertino.dart';

class Helper{
  static String? getAuthErr(String errorCode){
    String? _msg;
    switch(errorCode){
      case 'user-not-found':
        _msg = 'Pengguna tidak ditemukan';
        break;
      case 'invalid-email':
        _msg  = 'Alamat email tidak sesuai';
        break;
      case 'wrong-password':
        _msg  = 'Password salah';
        break;
      default:
        _msg = 'Gagal login';
        break;
    }

    return _msg;
  }
  static void requestFocusNode(BuildContext context)=>FocusScope.of(context).requestFocus(FocusNode());
}