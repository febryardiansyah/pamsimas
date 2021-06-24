import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';

class LoginScreen extends StatelessWidget {
  late Size _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: _size.width,
            height: _size.height * 0.4,
            child: Stack(
              children: [
                Positioned(
                  child: Image.asset(BaseString.vLightBlueVector,height: _size.height * 0.3,width: _size.height * 0.3,),
                  right: 0,
                  top: 0,
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Image.asset(BaseString.vBlueVector,height: _size.height * 0.4,width: _size.height * 0.4,)),
                Positioned(
                  top: _size.height * 0.14,
                  left: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selamat datang',style: GoogleFonts.rancho(color: Colors.white,fontSize: 40),),
                      Text('di aplikasi ${BaseString.appName}',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email'
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password'
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: BaseColor.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              )
            ),
            onPressed: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text('LOGIN'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('atau'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                )
            ),
            onPressed: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text('DAFTAR',style: TextStyle(color: BaseColor.lightBlue),),
            ),
          ),
        ],
      ),
    );
  }
}
