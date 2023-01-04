import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamsimas/bloc/sign_in/sign_in_cubit.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/helpers/routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Size _size;

  bool _isPasswordInvisible = true;

  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignInLoading) {
            EasyLoading.show(status: 'Tunggu sebentar');
          }
          if (state is SignInFailure) {
            EasyLoading.showError(state.msg!);
          }
          if (state is SignInSuccess) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess(state.msg!);
            Navigator.pushReplacementNamed(context, rHome);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: _size.width,
                height: _size.height * 0.4,
                child: Stack(
                  children: [
                    Positioned(
                      child: Image.asset(BaseString.vLightBlueVector,height: _size.height * 0.4,width: _size.height * 0.4,),
                      right: -40,
                      top: -100,
                    ),
                    Positioned(
                      left: -40,
                      top: -100,
                      child: Image.asset(BaseString.vBlueVector,height: _size.height * 0.5,width: _size.height * 0.5,)),
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
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(hintText: 'Username'),
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: _isPasswordInvisible,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordInvisible
                                ? Icons.lock_outline
                                : Icons.lock_open_outlined),
                            onPressed: () {
                              setState(() {
                                _isPasswordInvisible = !_isPasswordInvisible;
                              });
                            },
                          )),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: BaseColor.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  Helper.requestFocusNode(context);
                  context.read<SignInCubit>().signButtonPressed(
                      email: _email.text, password: _password.text);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text('Masuk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
