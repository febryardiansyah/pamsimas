import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/routes.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size _size;
  late List<HomeModel> _list;

  Future<void> _scanQr()async{
    try{
      await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    }catch(e){
      print(e);
    }
  }
  
  @override
  void initState() {
    super.initState();
    _list = [
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rHome),
        title: 'Cek Tagihan',color: Colors.lightBlue,icon: BaseString.iInvoice,
      ),
      HomeModel(
        onTap: _scanQr,
        title: 'Scan',color: Colors.lightBlue,icon: BaseString.iBarcode,
      ),
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rHome),
        title: 'Cek Data',color: Colors.lightBlue,icon: BaseString.iData,
      ),
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rHome),
        title: 'Bantuan',color: Colors.lightBlue,icon: BaseString.iTelephone,
      ),
      HomeModel(
        onTap: ()=>Navigator.pushNamed(context, rHome),
        title: 'Tambah Pengguna',color: Colors.lightBlue,icon: BaseString.iAddUser,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(BaseString.iMainLogo,height: 40,width: 100,fit: BoxFit.contain,),
                      Spacer(),
                      Icon(Icons.notifications,color: BaseColor.orange,)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo! Admin',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text('Admin',)
                    ],
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: _list.length,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,crossAxisSpacing: 30,mainAxisSpacing: 5,childAspectRatio: 1
                    ),
                    itemBuilder: (context,i){
                      final _item = _list[i];
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