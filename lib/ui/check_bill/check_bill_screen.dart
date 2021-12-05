import 'package:flutter/material.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';

class CheckBillScreen extends StatefulWidget {

  @override
  _CheckBillScreenState createState() => _CheckBillScreenState();
}

class _CheckBillScreenState extends State<CheckBillScreen> {
  late Size _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: _size.width,
                height: _size.height * 0.4,
                child: Stack(
                  children: [
                    Positioned(
                      top: -100,
                      right: -50,
                      left: -50,
                      child: GestureDetector(
                        onTap: ()=>Navigator.pop(context),
                        child: Image.asset(BaseString.vBlueVector,height: _size.height * 0.5,width: _size.width,fit: BoxFit.fill,),
                      )
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10,left: 10),
                          width: _size.width * 0.6,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                height: 40,
                                width: 40,
                                child: Center(child: Icon(Icons.arrow_back,color: BaseColor.white,),),
                                decoration: BoxDecoration(
                                  color: BaseColor.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(8),
                                height: 40,
                                child: Center(child: Text('TAGIHAN',style: TextStyle(fontWeight: FontWeight.bold,color: BaseColor.white),)),
                                decoration: BoxDecoration(
                                    color: BaseColor.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 40,),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: 170,
                            child: Center(child: Text('Rp 50.000',style: TextStyle(color: BaseColor.white,fontSize: 30,fontWeight: FontWeight.bold),),),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: BaseColor.white.withOpacity(0.3)
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.center,
                          child: Text('Silakan lakukan pembayaran di Waserda',style: TextStyle(color: BaseColor.white),),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Center(child: Text('Bulan ini',style: TextStyle(color: BaseColor.white,fontWeight: FontWeight.bold),)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: BaseColor.lightBlue
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Center(child: Text('Riwayat',style: TextStyle(color: BaseColor.white,fontWeight: FontWeight.bold),)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: BaseColor.lightBlue
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(),
                        SizedBox(height: 10,),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('Alamat',style: TextStyle(color: BaseColor.grey),),
                                Spacer(),
                                Text('Jl. Buntu')
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text('Pemakaian',style: TextStyle(color: BaseColor.grey),),
                                Spacer(),
                                Text('50 m3')
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(),
                        SizedBox(height: 10,),
                        Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Belum bayar',style: TextStyle(fontSize: 20),),
                              SizedBox(width: 8,),
                              Icon(Icons.cancel_outlined,color: BaseColor.red,)
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
