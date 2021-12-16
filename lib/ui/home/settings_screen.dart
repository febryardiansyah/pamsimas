import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pamsimas/bloc/auth/auth_cubit.dart';
import 'package:pamsimas/bloc/change_password/change_password_cubit.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/routes.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUnAuthenticated) {
              Navigator.pushNamedAndRemoveUntil(context, rLogin, (route) => false);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(FontAwesomeIcons.key),
                  title: Text('Ganti password'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: ()=>Navigator.pushNamed(context, rChangePassword),
                ),
                SizedBox(height: 50,),
                FlatButton(
                  onPressed: () {
                    context.read<AuthCubit>().loggedOut();
                  },
                  child: Text(
                    'Keluar', style: TextStyle(color: BaseColor.red),),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isOldPassInvisible = true;
  bool _isPassInvisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti password'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordLoading) {
              EasyLoading.show(status: 'Tunggu sebentar..');
            }
            if (state is ChangePasswordFailure) {
              EasyLoading.showError(state.msg!);
            }
            if (state is ChangePasswordSuccess) {
              EasyLoading.showSuccess(state.msg!);
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    validator: (val){
                      if (_emailCtrl.text.isEmpty) {
                        return 'Username tidak boleh kosong';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukan username kamu',
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _oldPassCtrl,
                    obscureText: _isOldPassInvisible,
                    validator: (val){
                      if (_oldPassCtrl.text.length < 6) {
                        return 'Password kurang dari 6';
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Masukan password lama',
                        suffixIcon: IconButton(
                          icon: Icon(_isOldPassInvisible?Icons.lock_outline_rounded:Icons.lock_open),
                          onPressed: (){
                            setState(() {
                              _isOldPassInvisible = !_isOldPassInvisible;
                            });
                          },
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _isPassInvisible,
                    validator: (val){
                      if (_passCtrl.text.length < 6) {
                        return 'Password kurang dari 6';
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Masukan password baru',
                        suffixIcon: IconButton(
                          icon: Icon(_isPassInvisible?Icons.lock_outline_rounded:Icons.lock_open),
                          onPressed: (){
                            setState(() {
                              _isPassInvisible = !_isPassInvisible;
                            });
                          },
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(height: 50,),
                  GestureDetector(
                    onTap: _passCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _oldPassCtrl.text.isEmpty?null:(){
                      if (_formKey.currentState!.validate()) {
                        print('new pass ${_passCtrl.text}');
                        context.read<ChangePasswordCubit>().changePass(
                          email: _emailCtrl.text,oldPassword: _oldPassCtrl.text,
                          newPassword: _passCtrl.text,
                        );
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _passCtrl.text.isEmpty?BaseColor.grey: BaseColor.greenDeep
                      ),
                      child: Center(
                        child: Text('Simpan',style: TextStyle(color: BaseColor.white),),
                      ),
                    ),
                  )
                ],
              ),
          ),
        ),),
      ),
    );
  }
}
