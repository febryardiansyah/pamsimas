import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Helper{
  static String? getAuthErr(String errorCode){
    String? _msg;
    print(errorCode);
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
      case 'email-already-in-use':
        _msg = 'Gunakan nama lain';
        break;
      default:
        _msg = 'Terjadi kesalahan';
        break;
    }

    return _msg;
  }
  static void requestFocusNode(BuildContext context)=>FocusScope.of(context).requestFocus(FocusNode());

  static String formatCurrency(int number){
    final _formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
    return _formatCurrency.format(number);
  }
}