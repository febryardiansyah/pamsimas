import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/ui/login_register/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: BaseString.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          button: GoogleFonts.josefinSans(),
          body1: GoogleFonts.josefinSans(),
        )
      ),
      home: LoginScreen(),
    );
  }
}

