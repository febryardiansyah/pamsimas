import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamsimas/bloc/auth/auth_cubit.dart';
import 'package:pamsimas/bloc/create_user/create_user_cubit.dart';
import 'package:pamsimas/bloc/input_user_bill/input_user_bill_cubit.dart';
import 'package:pamsimas/bloc/sign_in/sign_in_cubit.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/routes.dart';

import 'bloc/get_profile/get_profile_cubit.dart';
import 'bloc/get_user_by_uid/get_user_by_uid_cubit.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>AuthCubit()),
        BlocProvider(create: (_)=>SignInCubit()),
        BlocProvider(create: (_)=>GetProfileCubit()),
        BlocProvider(create: (_)=>GetUserByUidCubit()),
        BlocProvider(create: (_)=>CreateUserCubit()),
        BlocProvider(create: (_)=>InputUserBillCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: BaseString.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            button: GoogleFonts.josefinSans(),
            // body1: GoogleFonts.josefinSans(),
          )
        ),
        builder: EasyLoading.init(),
        initialRoute: rIndex,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

