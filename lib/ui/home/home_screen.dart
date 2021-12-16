import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamsimas/bloc/auth/auth_cubit.dart';
import 'package:pamsimas/bloc/get_profile/get_profile_cubit.dart';
import 'package:pamsimas/components/build_payed_status.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/helpers/routes.dart';
import 'package:pamsimas/model/history_model.dart';
import 'package:pamsimas/model/user_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size _size;
  late List<HomeModel> _adminMenuList;
  late List<HomeModel> _userMenuList;
  late List<HomeModel> _employeeList;
  UserModel? _userProfile;
  String? _name = '';
  String? _role = '';
  String? _uid = '';

  Future<void> _scanQr(BuildContext context)async{
    try{
      final _res = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(_res);
      Navigator.pushNamed(context, rScanResult,arguments: _res);
    }catch(e){
      print(e);
    }
  }
  
  @override
  void initState() {
    super.initState();
    context.read<GetProfileCubit>().fetchProfile();
    _userMenuList = [
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rCheckBill),
        title: 'Cek Tagihan',color: Colors.lightBlue,icon: BaseString.iInvoice,
      ),
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rHome),
        title: 'Bantuan',color: Colors.lightBlue,icon: BaseString.iTelephone,
      ),
    ];
    _adminMenuList = [
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rCheckData),
        title: 'Cek Data',color: Colors.lightBlue,icon: BaseString.iData,
      ),
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rAddCustomer),
        title: 'Tambah Pengguna',color: Colors.lightBlue,icon: BaseString.iAddUser,
      ),
    ];
    _employeeList = [
      HomeModel(
        onTap: ()=>_scanQr(context),
        title: 'Input Meteran',color: Colors.lightBlue,icon: BaseString.iMeter,
      ),
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rAddCustomer),
        title: 'Tambah Pengguna',color: Colors.lightBlue,icon: BaseString.iAddUser,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _name = context.select<GetProfileCubit,String>((value) => value.state is GetProfileSuccess?(value.state as GetProfileSuccess).data!.name!:'');
    _role = context.select<GetProfileCubit,String>((value) => value.state is GetProfileSuccess?(value.state as GetProfileSuccess).data!.role!:'');
    _uid = context.select<GetProfileCubit,String>((value) => value.state is GetProfileSuccess?(value.state as GetProfileSuccess).data!.uid!:'');
    _userProfile = context.select<GetProfileCubit,UserModel>((value) => value.state is GetProfileSuccess?(value.state as GetProfileSuccess).data!:UserModel());
    return Scaffold(
      body: BlocListener<AuthCubit,AuthState>(
        listener: (context,state){
          if (state is AuthUnAuthenticated) {
            EasyLoading.dismiss();
            Navigator.pushNamedAndRemoveUntil(context, rLogin, (route) => false);
          }
        },
        child: Stack(
          children: [
            Container(
              width: _size.width,
              height: _size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    BaseColor.lightBlue,
                    BaseColor.white,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: _size.height * 0.06,
                left: 15,
                right: 15,
              ),
              child:
              _role ==''?Center(child: CupertinoActivityIndicator(),):
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(BaseString.iMainLogo,height: 40,width: 100,fit: BoxFit.contain,),
                        Spacer(),
                        IconButton(
                          onPressed: (){

                          },
                          icon: Icon(Icons.notifications,color: BaseColor.orange,),
                        ),
                        IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.settings,color: BaseColor.grey,),
                        ),
                        IconButton(
                          onPressed: (){
                            context.read<AuthCubit>().loggedOut();
                          },
                          icon: Icon(Icons.logout_outlined,color: BaseColor.red,),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo! $_name',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 8,),
                        RichText(
                          text: TextSpan(
                            text: _role,
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: ' (${_userProfile?.uid}) ',
                                style: TextStyle(color: Colors.grey),
                              )
                            ]
                          ),
                        )
                      ],
                    ),
                    _role == 'Admin' || _role == 'Petugas'?Center():
                        Column(
                          children: [
                            SizedBox(height: 20,),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              ),
                              elevation: 4,
                              child: Container(
                                width: _size.width,
                                decoration: BoxDecoration(
                                  color: BaseColor.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Tagihan bulan ini'),
                                              SizedBox(height: 8,),
                                              Text(_userProfile?.bill == null?'Masih Kosong':Helper.formatCurrency(_userProfile!.bill!.currentBill!),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                                            ],
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(BaseString.iWaterTap)
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    _userProfile?.bill == null?Center():Container(
                                      width: _size.width,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                                        color: BaseColor.lightBlue.withOpacity(0.5),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Text(_userProfile!.bill!.isPayed!?'Sudah Bayar':'Belum Bayar',style: TextStyle(color: BaseColor.white),),
                                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: _userProfile!.bill!.isPayed!?BaseColor.greenDeep:BaseColor.red
                                            ),
                                          ),
                                          Spacer(),
                                          Text('${_userProfile!.bill!.month} ${_userProfile!.bill!.year}',style: TextStyle(color: BaseColor.grey),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, rQrCode,arguments: _uid);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                width: _size.width,
                                decoration: BoxDecoration(
                                  color: BaseColor.lightBlue,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text('Tampilkan QrCode',style: TextStyle(color: BaseColor.white,fontWeight: FontWeight.bold),),
                                      Spacer(),
                                      IconButton(
                                        onPressed: (){},
                                        icon: SvgPicture.asset(BaseString.iBarcode),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: _role == 'Admin'?_adminMenuList.length:_userMenuList.length,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,crossAxisSpacing: 30,mainAxisSpacing: 5,childAspectRatio: 1
                      ),
                      itemBuilder: (context,i){
                        final _item = _role == 'Admin' ?_adminMenuList[i]:_role == 'Petugas'?_employeeList[i]:_userMenuList[i];
                        return GestureDetector(
                          onTap: _item.onTap,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    BaseColor.darkBlue,
                                    BaseColor.lightBlue
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter
                                )
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(_item.icon!,),
                                      SizedBox(height: 8,),
                                      Text(_item.title!,style: GoogleFonts.josefinSans(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeModel{
  final String? icon;
  final String? title;
  final GestureTapCallback? onTap;
  final Color? color;

  HomeModel({this.icon, this.title, this.onTap, this.color});

}