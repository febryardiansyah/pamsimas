import 'package:flutter/material.dart';
import 'package:pamsimas/splash_screen.dart';
import 'package:pamsimas/ui/check_bill/check_bill_screen.dart';
import 'package:pamsimas/ui/create_user/create_user_screen.dart';
import 'package:pamsimas/ui/home/home_screen.dart';
import 'package:pamsimas/ui/index.dart';
import 'package:pamsimas/ui/login_register/login_screen.dart';
import 'package:pamsimas/ui/qr_code/qr_code_screen.dart';
import 'package:pamsimas/ui/qr_code/scan_result_screen.dart';

MaterialPageRoute _pageRoute({required RouteSettings settings,required Widget body})=>MaterialPageRoute(
  builder: (_) => body,
  settings: settings,
);

Route? generateRoute(RouteSettings settings){
  Route? _route;
  final _args = settings.arguments;
  switch(settings.name){
    case rSplash:
      _route = _pageRoute(settings: settings, body: SplashScreen());
      break;
    case rLogin:
      _route = _pageRoute(settings: settings, body: LoginScreen());
      break;
    case rHome:
      _route = _pageRoute(settings: settings, body: HomeScreen());
      break;
    case rIndex:
      _route = _pageRoute(settings: settings, body: IndexPage());
      break;
    case rQrCode:
      _route = _pageRoute(settings: settings, body: QrCodeScreen(uid: _args as String,));
      break;
    case rScanResult:
      _route = _pageRoute(settings: settings, body: ScanResultScreen(uid: _args as String,));
      break;
    case rAddCustomer:
      _route = _pageRoute(settings: settings, body: CreateUserScreen());
      break;
    case rCheckBill:
      _route = _pageRoute(settings: settings, body: CheckBillScreen());
      break;
  }
  return _route;
}

const String rSplash = '/splash';
const String rLogin = '/login';
const String rHome = '/home';
const String rIndex = '/index';
const String rQrCode = '/qrCode';
const String rScanResult = '/scanResult';
const String rAddCustomer = '/addCustomer';
const String rCheckBill = '/checkBill';