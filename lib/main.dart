import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamsimas/bloc/auth/auth_cubit.dart';
import 'package:pamsimas/bloc/change_password/change_password_cubit.dart';
import 'package:pamsimas/bloc/create_user/create_user_cubit.dart';
import 'package:pamsimas/bloc/get_all_user/get_all_user_cubit.dart';
import 'package:pamsimas/bloc/get_history_bill/get_history_bill_cubit.dart';
import 'package:pamsimas/bloc/input_user_bill/input_user_bill_cubit.dart';
import 'package:pamsimas/bloc/sign_in/sign_in_cubit.dart';
import 'package:pamsimas/bloc/update_payment_status/update_payment_status_cubit.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/routes.dart';

import 'bloc/get_data/get_data_cubit.dart';
import 'bloc/get_profile/get_profile_cubit.dart';
import 'bloc/get_report/get_report_cubit.dart';
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
        BlocProvider(create: (_)=>GetDataCubit()),
        BlocProvider(create: (_)=>GetHistoryBillCubit()),
        BlocProvider(create: (_)=>UpdatePaymentStatusCubit()),
        BlocProvider(create: (_)=>ChangePasswordCubit()),
        BlocProvider(create: (_)=>GetReportCubit()),
        BlocProvider(create: (_)=>GetAllUserCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: BaseString.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          )
        ),
        builder: EasyLoading.init(),
        initialRoute: rSplash,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

