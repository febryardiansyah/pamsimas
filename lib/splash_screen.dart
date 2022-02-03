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
        height: _size.height,
        width: _size.width,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                BaseString.iMainLogo,
                fit: BoxFit.contain,
              ),
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