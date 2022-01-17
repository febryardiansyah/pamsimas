import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pamsimas/bloc/create_user/create_user_cubit.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:pamsimas/repositories/user_repo.dart';

class CreateUserScreen extends StatefulWidget {

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  late Size _size;

  List<String> _roleList = ['Admin','Petugas','Pelanggan'];
  List<_CategoryModel> _categoryList = [
    _CategoryModel('R', 'Rumah Tangga'),
    _CategoryModel('B', 'Bisnis'),
    _CategoryModel('S', 'Sosial'),
    _CategoryModel('P', 'Pengurus'),
  ];

  final _nameCtrl = TextEditingController();
  List<String> _rtList = [];
  List<String> _rwList = [];
  String? _selectedRT;
  String? _selectedRW;
  String? _selectedRole;
  _CategoryModel? _selectedCategory;

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
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah pelanggan'),
        elevation: 0,
      ),
      backgroundColor: BaseColor.lightBlue,
      body: BlocListener<CreateUserCubit,CreateUserState>(
        listener: (context,state){
          if (state is CreateUserLoading) {
            EasyLoading.show(status: 'Tunggu sebentar');
          }
          if (state is CreateUserFailure) {
            EasyLoading.showError(state.msg!);
          }
          if (state is CreateUserSuccess) {
            EasyLoading.showSuccess(state.msg!);
          }
        },
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(BaseString.vWaterDrop,width: _size.width,height: _size.height,fit: BoxFit.cover,),
              top: -200,
            ),
            DraggableScrollableSheet(
              minChildSize: 0.7,
              maxChildSize: 1,
              initialChildSize: 0.7,
              builder: (context,scroll){
                return Container(
                  decoration: BoxDecoration(
                    color: BaseColor.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                    controller: scroll,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Isi data pelanggan baru dengan lengkap',style: TextStyle(fontSize: 20),),
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: _nameCtrl,
                            decoration: InputDecoration(
                              hintText: 'Nama',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                            ),
                          ),
                          SizedBox(height: 10,),
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
                                    setState(() {
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
                                    setState(() {
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
                          SizedBox(height: 10,),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedRole,
                            onChanged: (val){
                              setState(() {
                                if (_selectedRole == val) {
                                  _selectedRole = null;
                                } else {
                                  _selectedRole = val;
                                }
                              });
                            },
                            hint: Text('Role pengguna'),
                            items: _roleList.map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            )).toList(),
                          ),
                          SizedBox(height: 10,),
                          _selectedRole != 'Pelanggan'?Center():DropdownButton<_CategoryModel>(
                            isExpanded: true,
                            value: _selectedCategory,
                            onChanged: (val){
                              setState(() {
                                if (_selectedCategory == val) {
                                  _selectedCategory = null;
                                } else {
                                  _selectedCategory = val!;
                                }
                              });
                            },
                            hint: Text('Golongan'),
                            items: _categoryList.map((e) => DropdownMenuItem(
                              child: Text(e.label),
                              value: e,
                            )).toList(),
                          ),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: _nameCtrl.text.isEmpty || _selectedRT == null || _selectedRW == null || _selectedRole == null?null:(){
                              String _address = 'RT.$_selectedRT / RW.$_selectedRW';
                              context.read<CreateUserCubit>().createUser(
                                name: _nameCtrl.text,address: _address,
                                role: _selectedRole,category: _selectedCategory == null?'-':_selectedCategory?.id
                              );
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryModel {
  final String id;
  final String label;

  _CategoryModel(this.id, this.label);
}
