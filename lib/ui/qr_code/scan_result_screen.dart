import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pamsimas/bloc/get_user_by_uid/get_user_by_uid_cubit.dart';
import 'package:pamsimas/bloc/input_user_bill/input_user_bill_cubit.dart';
import 'package:pamsimas/components/build_category.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/helpers/helper.dart';

class ScanResultScreen extends StatefulWidget {
  final String? uid;

  const ScanResultScreen({Key? key, this.uid}) : super(key: key);

  @override
  _ScanResultScreenState createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  late Size _size;
  String? _selectedMonth;
  String _category = '';
  bool _isLastBillManual = false;
  final _lastBillCtrl = TextEditingController();
  DateTime _currentDate = DateTime.now();
  TextEditingController _currentYear = TextEditingController();
  List<String> _monthList = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'];
  TextEditingController _inputCtrl = TextEditingController();
  int _lastBill = 700;
  int _totalBill = 0;

  @override
  void initState() {
    super.initState();
    context.read<GetUserByUidCubit>().fetchUserByUid(widget.uid!);
  }
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('INPUT METERAN'),
      ),
      body: BlocListener<InputUserBillCubit,InputUserBillState>(
        listener: (context,state){
          if (state is InputUserBillLoading) {
            EasyLoading.show(status: 'Tunggu sebentar..');
          } if (state is InputUserBillFailure) {
            EasyLoading.showError(state.msg!);
          }
          if (state is InputUserBillSuccess) {
            EasyLoading.showSuccess(state.msg!);
          }
        },
        child: BlocBuilder<GetUserByUidCubit,GetUserByUidState>(
          builder: (context,state){
            if (state is GetUserByUidLoading) {
              return Center(child: CupertinoActivityIndicator(),);
            }
            if (state is GetUserByUidFailure) {
              return Center(child: Text(state.msg!),);
            }
            if (state is GetUserByUidSuccess) {
              final _data = state.data!;
              _category = _data.category ?? '';
              return Stack(
                children: [
                  Positioned(
                    child: Image.asset(BaseString.vWaterDrop,width: _size.width,height: _size.height,fit: BoxFit.cover,),
                    top: -200,
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    maxChildSize: 1,
                    minChildSize: 0.7,
                    builder: (context,scrollCtrl){
                      return Container(
                        decoration: BoxDecoration(
                          color: BaseColor.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                        child: SingleChildScrollView(
                          controller: scrollCtrl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(),
                                  SizedBox(width: 8,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_data.name!,style: TextStyle(fontSize: 20),),
                                      SizedBox(height: 8,),
                                      Text('Meteran Lalu : 700'),
                                    ],
                                  ),
                                  Spacer(),
                                  BuildCategory(category: _category,)
                                ],
                              ),
                              SizedBox(height: 8,),
                              Divider(),
                              // SwitchListTile(
                              //   title: Text('Meteran bulan lalu'),
                              //   value: _isLastBillManual,
                              //   activeColor: BaseColor.lightBlue,
                              //   onChanged: (val){
                              //     setState(() {
                              //       _isLastBillManual = val;
                              //     });
                              //   },
                              // ),
                              // !_isLastBillManual?Center():
                              // TextFormField(
                              //   controller: _lastBillCtrl,
                              //   keyboardType: TextInputType.number,
                              //   decoration: InputDecoration(
                              //     hintText: 'Input meteran',
                              //     label: Text('Meteran bulan lalu'),
                              //   ),
                              // ),
                              SizedBox(height: 10,),
                              SizedBox(height: 8,),
                              TextFormField(
                                controller: _inputCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Input Meteran',
                                    label: Text('Meter Sekarang')
                                    // border: OutlineInputBorder(
                                    //     borderRadius: BorderRadius.circular(8)
                                    // )
                                ),
                              ),
                              SizedBox(height: 20,),
                              DropdownButton<String>(
                                isExpanded: true,
                                hint: Text('Bulan'),
                                borderRadius: BorderRadius.circular(8),
                                value: _selectedMonth,
                                onChanged: (val){
                                  setState(() {
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
                              SizedBox(height: 20,),
                              TextFormField(
                                controller: _currentYear,
                                decoration: InputDecoration(
                                  hintText: 'Tahun',
                                  label: Text('Tahun')
                                ),
                                onTap: (){
                                  Helper.requestFocusNode(context);
                                  _showYearPicker();
                                },
                              ),
                              SizedBox(height: 30,),
                              GestureDetector(
                                onTap:_inputCtrl.text.isEmpty || _selectedMonth == null || _currentYear.text.isEmpty?null: (){
                                  int _bill = _calculateBill();
                                  _showCalculationResult(_bill);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  width: _size.width,
                                  child: Center(child: Text('Hitung Tagihan',style: TextStyle(fontWeight: FontWeight.bold,color: BaseColor.white,fontSize: 15),)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: BaseColor.green
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  int _calculateBill(){
    int _priceByCategory = 0;
    switch(_category){
      case 'P':
        _priceByCategory = 1000;
        break;
      case 'R':
        _priceByCategory = 2000;
        break;
      case 'B':
        _priceByCategory = 3000;
        break;
      case 'S':
        _priceByCategory = 4000;
        break;
      default:
        _priceByCategory = 5000;
        break;
    }
    int _input = int.parse(_inputCtrl.text);
    int _mt = _input - _lastBill;
    int _res = (_mt ~/ 20).toInt();
    int _bill = _priceByCategory * _res;
    setState(() {
      _totalBill = _bill;
    });
    return _bill;
  }

  void _showCalculationResult(int bill){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text('Konfirmasi tagihan'),
      content: Text('${Helper.formatCurrency(_totalBill)}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
      actions: [
        ElevatedButton(
          child: Text('Input',style: GoogleFonts.roboto(color: BaseColor.white),),
          onPressed: (){
            Navigator.pop(context);
            context.read<InputUserBillCubit>().inputBill(
              uid: widget.uid!, currentBill: bill, month: _selectedMonth!,year: _currentYear.text,
              usage: _inputCtrl.text
            );
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
