import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamsimas/bloc/auth/auth_cubit.dart';
import 'package:pamsimas/ui/home/home_screen.dart';
import 'package:pamsimas/ui/login_register/login_screen.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().appStarted();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit,AuthState>(
        builder: (context,state){
          if (state is AuthAuthenticated) {
            return HomeScreen();
          }
          if (state is AuthUnAuthenticated) {
            return LoginScreen();
          }
          return Container();
        },
      ),
    );
  }
}
