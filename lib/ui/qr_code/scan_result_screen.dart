import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamsimas/bloc/get_user_by_uid/get_user_by_uid_cubit.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';

class ScanResultScreen extends StatefulWidget {
  final String? uid;

  const ScanResultScreen({Key? key, this.uid}) : super(key: key);

  @override
  _ScanResultScreenState createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  late Size _size;
  String? _selectedMonth;
  List<String> _monthList = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'];
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
      body: BlocBuilder<GetUserByUidCubit,GetUserByUidState>(
        builder: (context,state){
          if (state is GetUserByUidLoading) {
            return Center(child: CupertinoActivityIndicator(),);
          }
          if (state is GetUserByUidFailure) {
            return Center(child: Text(state.msg!),);
          }
          if (state is GetUserByUidSuccess) {
            final _data = state.data!;
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(),
                                SizedBox(width: 8,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_data.name!,style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 8,),
                                    Text('Meteran Lalu : 700')
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 8,),
                            Divider(),
                            SizedBox(height: 8,),
                            TextFormField(
                              // controller: _addressCtrl,
                              decoration: InputDecoration(
                                  hintText: 'Input Meteran',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  )
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
                            SizedBox(height: 30,),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                width: _size.width,
                                child: Center(child: Text('Input',style: TextStyle(fontWeight: FontWeight.bold,color: BaseColor.white,fontSize: 15),)),
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
                  },
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
