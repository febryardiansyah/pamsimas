import 'package:flutter/material.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pamsimas/splash_screen.dart';
import 'package:pamsimas/ui/check_bill/check_bill_screen.dart';
import 'package:pamsimas/ui/check_bill/history_bill_screen.dart';
import 'package:pamsimas/ui/check_bill/invoice_screen.dart';
import 'package:pamsimas/ui/check_data/check_customers_screen.dart';
import 'package:pamsimas/ui/check_data/check_data_screen.dart';
import 'package:pamsimas/ui/check_data/download_all_qr_code.dart';
import 'package:pamsimas/ui/check_data/download_all_user_account.dart';
import 'package:pamsimas/ui/check_data/download_user_account.dart';
import 'package:pamsimas/ui/check_data/user_account_screen.dart';
import 'package:pamsimas/ui/check_data/user_data_screen.dart';
import 'package:pamsimas/ui/create_user/create_user_screen.dart';
import 'package:pamsimas/ui/home/home_screen.dart';
import 'package:pamsimas/ui/home/settings_screen.dart';
import 'package:pamsimas/ui/index.dart';
import 'package:pamsimas/ui/login_register/login_screen.dart';
import 'package:pamsimas/ui/qr_code/qr_code_screen.dart';
import 'package:pamsimas/ui/qr_code/scan_result_screen.dart';
import 'package:pamsimas/ui/report/download_report_screen.dart';
import 'package:pamsimas/ui/report/report_screen.dart';

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
    case rCheckData:
      _route = _pageRoute(settings: settings, body: CheckDataScreen());
      break;
    case rUserData:
      _route = _pageRoute(settings: settings, body: UserDataScreen(uid: _args as String));
      break;
    case rHistoryBill:
      _route = _pageRoute(settings: settings, body: HistoryBillScreen());
      break;
    case rSettings:
      _route = _pageRoute(settings: settings, body: SettingsScreen());
      break;
    case rChangePassword:
      _route = _pageRoute(settings: settings, body: ChangePasswordScreen());
      break;
    case rInvoice:
      _route = _pageRoute(settings: settings, body: InvoiceScreen(data: _args as UserModel,));
      break;
    case rReport:
      _route = _pageRoute(settings: settings, body: ReportScreen());
      break;
    case rDownloadReport:
      _route = _pageRoute(settings: settings, body: DownloadReportScreen(data: _args as DownloadReportParams,));
      break;
    case rUserAccount:
      _route = _pageRoute(settings: settings, body: UserAccountScreen(data: _args as UserModel,));
      break;
    case rDownloadUserAccount:
      _route = _pageRoute(settings: settings, body: DownloadUserAccount(user: _args as UserModel));
      break;
    case rDownloadAllQrCode:
      _route = _pageRoute(settings: settings, body: DownloadAllQrCode());
      break;
    case rDownloadAllUserAccount:
      _route = _pageRoute(settings: settings, body: DownloadAllUserAccount());
      break;
    case rCheckCustomers:
      _route = _pageRoute(settings: settings, body: CheckCustomerScreen());
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
const String rCheckData = '/CheckData';
const String rUserData = '/userData';
const String rHistoryBill = '/historyBill';
const String rSettings = '/settings';
const String rChangePassword = '/changePassword';
const String rInvoice = '/invoice';
const String rReport = '/report';
const String rDownloadReport = '/downloadReport';
const String rUserAccount = '/userAccount';
const String rDownloadUserAccount = '/downloadUserAccount';
const String rDownloadAllQrCode = '/downloadAllQrCode';
const String rDownloadAllUserAccount = '/downloadAllUserAccount';
const String rCheckCustomers = '/checkCustomers';