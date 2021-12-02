import 'package:flutter/material.dart';
import 'package:pamsimas/helpers/base_color.dart';

class AddCustomerScreen extends StatefulWidget {

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  late Size _size;

  List<String> _roleList = ['Admin','Petugas','Pelanggan'];
  List<_CategoryModel> _categoryList = [
    _CategoryModel('R', 'Rumah Tangga'),
    _CategoryModel('B', 'Bisnis'),
    _CategoryModel('S', 'Sosial'),
    _CategoryModel('P', 'Pengurus'),
  ];

  String? _selectedRole;
  _CategoryModel? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah pelanggan'),
      ),
      backgroundColor: BaseColor.lightBlue,
      body: DraggableScrollableSheet(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Isi data pelanggan baru dengan lengkap',style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Alamat',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
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
                      onTap: (){},
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
    );
  }
}

class _CategoryModel {
  final String id;
  final String label;

  _CategoryModel(this.id, this.label);
}
