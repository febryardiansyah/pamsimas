import 'package:flutter/material.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/routes.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Size _size;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushReplacementNamed(context, rIndex);
    });
  }
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(BaseString.iMainLogo,width: _size.width * 0.2,height: _size.height * 0.2,fit: BoxFit.contain,),
            ),
            Positioned(
              bottom: -100,
              child: Image.asset(BaseString.vSplashVector,height: _size.height * 0.5,width: _size.width),),
          ],
        ),
      ),
    );
  }
}