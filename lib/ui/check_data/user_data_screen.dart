import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamsimas/bloc/get_history_bill/get_history_bill_cubit.dart';
import 'package:pamsimas/bloc/get_user_by_uid/get_user_by_uid_cubit.dart';
import 'package:pamsimas/bloc/update_payment_status/update_payment_status_cubit.dart';
import 'package:pamsimas/components/build_category.dart';
import 'package:pamsimas/components/status_card.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserDataScreen extends StatefulWidget {
  final String uid;

  const UserDataScreen({Key? key,required this.uid}) : super(key: key);
  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  late Size _size;
  final _totalPaidCtrl = TextEditingController();
  final _refreshController = RefreshController(initialRefresh: false);
  bool _hasReachedMax = false;
  String? _lastBillId;
  List<_StatusModel> _statusList = [
    _StatusModel('Sudah Bayar', true),
    _StatusModel('Belum Bayar', false),
  ];

  @override
  void initState() {
    super.initState();
    context.read<GetUserByUidCubit>().fetchUserByUid(widget.uid);
    context.read<GetHistoryBillCubit>().fetchHistory(uid: widget.uid);
  }
  @override
  Widget build(BuildContext context) {
    _hasReachedMax = context.select<GetHistoryBillCubit,bool>((bloc) => bloc.state is GetHistoryBillSuccess?
    (bloc.state as GetHistoryBillSuccess).hasReachedMax!:false);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: BaseColor.grey.withOpacity(0.1),
      appBar: AppBar(
        elevation: 0,
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: BlocListener<UpdatePaymentStatusCubit,UpdatePaymentStatusState>(
          listener: (context,state){
            if (state is UpdatePaymentStatusLoading) {
              EasyLoading.show(status: 'Tunggu sebentar...');
            }
            if (state is UpdatePaymentStatusFailure) {
              EasyLoading.showError(state.msg!);
            }
            if (state is UpdatePaymentStatusSuccess) {
              _totalPaidCtrl.clear();
              context.read<GetUserByUidCubit>().fetchUserByUid(widget.uid);
              context.read<GetHistoryBillCubit>().fetchHistory(uid: widget.uid);
              EasyLoading.showSuccess(state.msg!);
            }
          },
          child: BlocBuilder<GetUserByUidCubit,GetUserByUidState>(
            builder: (context,state) {
              if (state is GetUserByUidLoading) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (state is GetUserByUidFailure) {
                return Center(child: Text(state.msg!),);
              }
              if (state is GetUserByUidSuccess) {
                final _data = state.data!;
                return SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: _hasReachedMax?false:true,
                  onLoading: (){
                    context.read<GetHistoryBillCubit>().onLoading(uid: widget.uid);
                    _refreshController.loadComplete();
                  },
                  onRefresh: (){
                    context.read<GetUserByUidCubit>().fetchUserByUid(widget.uid);
                    context.read<GetHistoryBillCubit>().fetchHistory(uid: widget.uid);
                    _refreshController.refreshCompleted();
                  },
                  header: WaterDropMaterialHeader(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Container(
                            width: _size.width,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(),
                                    SizedBox(width: 14,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_data.name!,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                        Row(
                                          children: [
                                            BuildCategory(category: _data.category,),
                                            SizedBox(width: 8,),
                                            Text('(${_data.uid})',style: TextStyle(color: BaseColor.grey),)
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Divider(),
                                SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Text('Alamat',style: TextStyle(color: BaseColor.grey),),
                                    Spacer(),
                                    Text(_data.address!)
                                  ],
                                ),
                                _data.bill == null?
                                Center(child: Text('Belum ada data')):
                                Column(
                                      children: [
                                        SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text('Pemakaian bulan ini',style: TextStyle(color: BaseColor.grey),),
                                            Spacer(),
                                            Text('${_data.bill!.currentUsage} m3')
                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text('Periode tagihan',style: TextStyle(color: BaseColor.grey),),
                                            Spacer(),
                                            Text('${_data.bill!.month} ${_data.bill!.year}')
                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text('Tagihan bulan ini',style: TextStyle(color: BaseColor.grey),),
                                            Spacer(),
                                            Text(Helper.formatCurrency(_data.bill!.currentBill!))
                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text('Total dibayarkan',style: TextStyle(color: BaseColor.grey),),
                                            Spacer(),
                                            Text(_data.bill!.totalPaid == null?'Rp0,00':Helper.formatCurrency(_data.bill!.totalPaid!))
                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text('Status',style: TextStyle(color: BaseColor.grey),),
                                            Spacer(),
                                            Text(_data.bill!.isPayed! ? 'Lunas':'Belum Lunas')
                                          ],
                                        ),
                                        SizedBox(height: 15,),
                                        Center(
                                          child: FlatButton(
                                            onPressed: (){
                                              _showChangeStatus(true,null,_data.bill!.currentBill!,_data.bill!.totalPaid!,0);
                                            },
                                            child: Text('Ubah Status',style: TextStyle(color: BaseColor.red),),
                                          ),
                                        )
                                      ],
                                    ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text('Riwayat Tagihan'),
                        SizedBox(height: 10,),
                        BlocBuilder<GetHistoryBillCubit,GetHistoryBillState>(
                          builder: (context,state){
                            if (state is GetHistoryBillLoading) {
                              return Center(child: CupertinoActivityIndicator(),);
                            }
                            if (state is GetHistoryBillFailure) {
                              return Center(child: Text(state.msg!),);
                            }
                            if (state is GetHistoryBillSuccess) {
                              final _data = state.data!;
                              _lastBillId = _data.isEmpty?null:_data[0].id;
                              return _data.isEmpty?Center(
                                child: Text('Masih Kosong'),
                              ): ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: _data.length,
                                itemBuilder: (context,i){
                                  final _item = _data[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: StatusCard(
                                      onTap: (){
                                        print(i);
                                        if (i == 0) {
                                          _showChangeStatus(true,_lastBillId,_item.currentBill!,_item.totalPaid!,i);
                                        } else {
                                          _showChangeStatus(false,_item.id!,_item.currentBill!,_item.totalPaid!,i);
                                        }
                                      },
                                      data: _item,
                                    ),
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }
          ),
        ),
      ),
    );
  }

  void _showChangeStatus(bool userCollection,String? id,int currentBill,int totalPaid,int? index){
    showModalBottomSheet(context: context,isScrollControlled: true,shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10))
    ), builder: (context)=>Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: _size.height * 0.3,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total dibayar :',style: TextStyle(fontWeight: FontWeight.bold),),
              TextFormField(
                controller: _totalPaidCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukan total yang dibayarkan'
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap:_totalPaidCtrl.text.isEmpty?null: (){
                  _showDialogConfirmation(
                    totalPaid: totalPaid,currentBill: currentBill,
                    userCollection: userCollection,index: index,id: id
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  width: _size.width,
                  child: Center(child: Text('Konfirmasi',style: TextStyle(fontWeight: FontWeight.bold,color: BaseColor.white,fontSize: 15),)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: BaseColor.green
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _showDialogConfirmation({int? currentBill,int? totalPaid,bool? userCollection,String? id,int? index}){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text('Konfirmasi pembayaran'),
      content: Text('${Helper.formatCurrency(int.parse(_totalPaidCtrl.text))}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
      actions: [
        ElevatedButton(
          child: Text('Input',style: GoogleFonts.roboto(color: BaseColor.white),),
          onPressed: (){
            Navigator.pop(context);
            int _res = totalPaid! + int.parse(_totalPaidCtrl.text);
            print(currentBill);
            if (_res > currentBill!) {
              EasyLoading.showError('Melebihi batas');
            } else if (currentBill == _res) {
              context.read<UpdatePaymentStatusCubit>().updateStatus(
                uid: widget.uid, status: true,userCollection: userCollection!,id: id == null?_lastBillId:id,
                totalPaid:int.parse(_totalPaidCtrl.text),totalCurrentPaid: totalPaid,index: index
              );
            } else {
              context.read<UpdatePaymentStatusCubit>().updateStatus(
                uid: widget.uid, status: false,userCollection: userCollection!,id: id == null?_lastBillId:id,
                totalPaid: int.parse(_totalPaidCtrl.text),totalCurrentPaid: totalPaid,index: index
              );
            }
          },
          style: ElevatedButton.styleFrom(
              primary: BaseColor.green,
              padding: EdgeInsets.symmetric(horizontal: 30),
              elevation: 0
          ),
        ),
        ElevatedButton(
          child: Text('Batal',style: GoogleFonts.roboto(color: BaseColor.white),),
          onPressed: ()=>Navigator.pop(context),
          style: ElevatedButton.styleFrom(
              primary: BaseColor.red,
              padding: EdgeInsets.symmetric(horizontal: 30),
              elevation: 0
          ),
        ),
      ],
    ));
  }
}

class _StatusModel{
  final String label;
  final bool status;

  _StatusModel(this.label, this.status);
}
