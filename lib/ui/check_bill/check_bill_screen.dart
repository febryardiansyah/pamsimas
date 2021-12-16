import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pamsimas/bloc/get_profile/get_profile_cubit.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/helpers/routes.dart';

class CheckBillScreen extends StatefulWidget {

  @override
  _CheckBillScreenState createState() => _CheckBillScreenState();
}

class _CheckBillScreenState extends State<CheckBillScreen> {
  late Size _size;
  @override
  void initState() {
    super.initState();
    context.read<GetProfileCubit>().fetchProfile();
  }
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<GetProfileCubit,GetProfileState>(
          builder: (context,state) {
            if (state is GetProfileLoading) {
              return Center(child: CupertinoActivityIndicator(),);
            }
            if (state is GetProfileFailure) {
              return Center(child: Text(state.msg!),);
            }
            if (state is GetProfileSuccess) {
              final _data = state.data!;
              return SingleChildScrollView(
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
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Center(child: Text(_data.bill == null?'':Helper.formatCurrency(_data.bill!.currentBill!),style: TextStyle(color: BaseColor.white,fontSize: 30,fontWeight: FontWeight.bold),),),
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
                    _data.bill == null?Center(
                      child: Text('Belum ada data'),
                    ):Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text('Bulan Ini',style: TextStyle(fontSize: 25),),
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
                                      Text(_data.address!)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Text('Pemakaian',style: TextStyle(color: BaseColor.grey),),
                                      Spacer(),
                                      Text('${_data.bill!.usage} m3')
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Divider(),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Container(
                                    child: Text(_data.bill!.isPayed!?'Sudah Bayar':'Belum Bayar',style: TextStyle(color: BaseColor.white),),
                                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: _data.bill!.isPayed!?BaseColor.greenDeep:BaseColor.red,
                                    ),
                                  ),
                                  Spacer(),
                                  Text('${_data.bill!.month} ${_data.bill!.year}',style: TextStyle(color: BaseColor.grey),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.fileInvoice),
                                title: Text('Lihat Invoice'),
                                subtitle: Text('Invoice tagihan bulan ini'),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: (){},
                              ),
                              Divider(),
                              SizedBox(height: 10,),
                              ListTile(
                                title: Text('Riwayat Tagihan'),
                                subtitle: Text('Lihat tagihan bulan sebelumnya'),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: ()=>Navigator.pushNamed(context, rHistoryBill),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return Container();
          }
        ),
      ),
    );
  }
}
