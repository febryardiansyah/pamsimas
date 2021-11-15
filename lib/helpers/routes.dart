import 'package:flutter/material.dart';
import 'package:pamsimas/splash_screen.dart';
import 'package:pamsimas/ui/home/home_screen.dart';
import 'package:pamsimas/ui/index.dart';
import 'package:pamsimas/ui/login_register/login_screen.dart';

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
  }
  return _route;
}

const String rSplash = '/splash';
const String rLogin = '/login';
const String rHome = '/home';
const String rIndex = '/index';