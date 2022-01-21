import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pamsimas/bloc/get_report/get_report_cubit.dart';
import 'package:pamsimas/components/build_category.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/helpers/routes.dart';
import 'package:pamsimas/repositories/user_repo.dart';
import 'package:collection/collection.dart';

import 'download_report_screen.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<String> _rtList = [];
  List<String> _rwList = [];
  String? _selectedRT;
  String? _selectedRW;
  String? _selectedMonth;
  List<String> _monthList = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'];
  final _currentYear = TextEditingController();
  DateTime _currentDate = DateTime.now();
  Future<void> _setAddress()async{
    _rtList = await UserRepo.getAddress(address: 'RT');
    _rwList = await UserRepo.getAddress(address: 'RW');
  }
  @override
  void initState() {
    super.initState();
    _setAddress();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        context.read<GetReportCubit>().clear();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Laporan'),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.assignment),
                        title: Text('Rekap'),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text('Laporan Bulanan',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        Spacer(),
                        GestureDetector(
                          onTap: _showFilter,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.filter_list),
                                SizedBox(width: 5,),
                                Text('Filter')
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    BlocBuilder<GetReportCubit, GetReportState>(
                      builder: (context, state) {
                        if (state is GetReportLoading) {
                          return Center(child: CupertinoActivityIndicator(),);
                        }
                        if (state is GetReportFailure) {
                          return Center(child: Text(state.msg),);
                        }
                        if (state is GetReportSuccess) {
                          final _data = state.data;
                          return _data.isEmpty?Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text('Data masih kosong'),
                            ),
                          ): Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: ()=>Navigator.pushNamed(context, rDownloadReport,arguments: DownloadReportParams(
                                      user: _data,date: '$_selectedMonth ${_currentYear.text}',
                                      address: 'RT.$_selectedRT / RW.$_selectedRW'
                                    )),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          width: 1,color: BaseColor.red
                                        )
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.print,color: BaseColor.red,),
                                            SizedBox(width: 4,),
                                            Text('Download',style: TextStyle(color: BaseColor.red),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Periode : $_selectedMonth ${_currentYear.text}'),
                                      Text('Wilayah : RT.$_selectedRT / RW.$_selectedRW')
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 8,),
                              ListView.builder(
                                itemCount: _data.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context,i){
                                  final _item = _data[i];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('${i+1}. ${_item.name!}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                              Spacer(),
                                              BuildCategory(category: _item.category,)
                                            ],
                                          ),
                                          SizedBox(height: 4,),
                                          Text('(${_item.uid})',style: TextStyle(color: BaseColor.grey),),
                                          SizedBox(height: 8,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Meteran : '),
                                              Spacer(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Lalu'),
                                                  Text('${_item.bill!.lastUsage}',style: TextStyle(fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              SizedBox(width: 24,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Sekarang'),
                                                  Text('${_item.bill!.currentUsage}',style: TextStyle(fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Vol(m3) : '),
                                              Spacer(),
                                              Text('${_item.bill!.currentUsage! - _item.bill!.lastUsage!}',style: TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Tagihan : '),
                                              Spacer(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Lalu'),
                                                  Text('${Helper.formatCurrency(_item.bill!.lastBill!)}',style: TextStyle(fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              SizedBox(width: 24,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Sekarang'),
                                                  Text('${Helper.formatCurrency(_item.bill!.currentBill!)}',style: TextStyle(fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Tagihan : '),
                                              Spacer(),
                                              Text('${Helper.formatCurrency(_item.bill!.lastBill! + _item.bill!.currentBill!)}',style: TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Dibayar : '),
                                              Spacer(),
                                              Text('${Helper.formatCurrency(_item.bill!.totalPaid!)}',style: TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Sisa tagihan : '),
                                              Spacer(),
                                              Text('${Helper.formatCurrency((_item.bill!.lastBill! + _item.bill!.currentBill!) - _item.bill!.totalPaid!)}',style: TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('Belum ada data, silahkan filter terlebih dahulu.'),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<GetReportCubit, GetReportState>(
              builder: (context, state) {
                if (state is GetReportSuccess) {
                  final _data = state.data;
                  int _lastUsage = 0;
                  int _currentUsage = 0;
                  int _vol = 0;
                  int _lastBill = 0;
                  int _currentBill = 0;
                  int _totalBill = 0;
                  int _totalPaid = 0;
                  int _remain = 0;
                  for(int i =0;i<_data.length;i++){
                    _lastUsage += _data[i].bill!.lastUsage!;
                    _currentUsage += _data[i].bill!.currentUsage!;
                    _vol += _data[i].bill!.currentUsage! - _data[i].bill!.lastUsage!;
                    _lastBill += _data[i].bill!.lastBill!;
                    _currentBill += _data[i].bill!.currentBill!;
                    _totalBill += _data[i].bill!.lastBill!+ _data[i].bill!.currentBill!;
                    _totalPaid += _data[i].bill!.totalPaid!;
                    _remain += (_data[i].bill!.lastBill!+_data[i].bill!.currentBill!) - _data[i].bill!.totalPaid!;
                  }
                  return _data.isEmpty?Center():DraggableScrollableSheet(
                    initialChildSize: 0.1,
                    expand: true,
                    maxChildSize: 0.6,
                    minChildSize: 0.1,
                    builder: (context,scroll){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            color: BaseColor.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(-2,-2),
                                color: BaseColor.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                              )
                            ]
                        ),
                        padding: EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          controller: scroll,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 100,
                                  height: 2,
                                  color: BaseColor.grey.withOpacity(0.5),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Center(
                                child: Text('Grand Total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              ),
                              SizedBox(height: 8,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Meteran : '),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Lalu'),
                                          Text('$_lastUsage',style: TextStyle(fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      SizedBox(width: 24,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Sekarang'),
                                          Text('$_currentUsage',style: TextStyle(fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Vol(m3) : '),
                                      Spacer(),
                                      Text('$_vol',style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Tagihan : '),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Lalu'),
                                          Text('${Helper.formatCurrency(_lastBill)}',style: TextStyle(fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      SizedBox(width: 24,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Sekarang'),
                                          Text('${Helper.formatCurrency(_currentBill)}',style: TextStyle(fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Tagihan : '),
                                      Spacer(),
                                      Text('${Helper.formatCurrency(_totalBill)}',style: TextStyle(fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Dibayar : '),
                                      Spacer(),
                                      Text('${Helper.formatCurrency(_totalPaid)}',style: TextStyle(fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Sisa Tagihan : '),
                                      Spacer(),
                                      Text('${Helper.formatCurrency(_remain)}',style: TextStyle(fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilter(){
    showModalBottomSheet(context: context,isScrollControlled: true,shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8))
    ), builder: (context)=>StatefulBuilder(
      builder: (context,myState) {
        return Container(
          margin: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Divider(),
                Text('Bulan'),
                DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Pilih Bulan'),
                  borderRadius: BorderRadius.circular(8),
                  value: _selectedMonth,
                  onChanged: (val){
                    myState(() {
                      if (_selectedMonth == val) {
                        _selectedMonth = null;
                      } else {
                        _selectedMonth = val;
                      }
                    });
                  },
                  items: _monthList.map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  )).toList(),
                ),
                SizedBox(height: 8,),
                Text('Tahun'),
                TextFormField(
                  controller: _currentYear,
                  decoration: InputDecoration(
                      hintText: 'Pilih Tahun',
                      label: Text('Tahun')
                  ),
                  onTap: (){
                    Helper.requestFocusNode(context);
                    _showYearPicker();
                  },
                ),
                SizedBox(height: 8,),
                Text('Alamat'),
                Row(
                  children: [
                    Text('RT : ',style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedRT,
                        onChanged: (val){
                          myState(() {
                            if (_selectedRT == val) {
                              _selectedRT = null;
                            } else {
                              _selectedRT = val;
                            }
                          });
                        },
                        hint: Text('Nomor RT'),
                        items: _rtList.map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        )).toList(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('RW : ',style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedRW,
                        onChanged: (val){
                          myState(() {
                            if (_selectedRW == val) {
                              _selectedRW = null;
                            } else {
                              _selectedRW = val;
                            }
                          });
                        },
                        hint: Text('Nomor RW'),
                        items: _rwList.map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        )).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                _selectedMonth == null || _currentYear.text.isEmpty || _selectedRT == null || _selectedRW == null?Container():
                GestureDetector(
                  onTap:(){
                    context.read<GetReportCubit>().fetchReport(
                      month: _selectedMonth!, year: _currentYear.text, rt: _selectedRT!, rw: _selectedRW!,
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text('Terapkan',style: TextStyle(fontWeight: FontWeight.bold,color: BaseColor.white,fontSize: 15),)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: BaseColor.green
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    ));
  }
  void _showYearPicker(){
    showDialog(context: context, builder: (context)=>StatefulBuilder(
      builder:(context,myState) => AlertDialog(
        title: Text('Pilih tahun'),
        content: Container(
          width: 300,
          height: 300,
          child: YearPicker(
            firstDate: DateTime(DateTime.now().year - 100, 1),
            lastDate: DateTime(DateTime.now().year + 100, 1),
            initialDate: DateTime.now(),
            selectedDate: DateTime.now(),
            currentDate: _currentDate,
            onChanged: (DateTime val){
              String _year = DateFormat('yyyy').format(val);
              myState(() {
                _currentDate = val;
              });
              setState(() {
                _currentYear.text = _year;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    ));
  }
}
