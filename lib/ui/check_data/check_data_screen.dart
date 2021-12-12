import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pamsimas/bloc/get_data/get_data_cubit.dart';
import 'package:pamsimas/components/build_category.dart';
import 'package:pamsimas/components/build_payed_status.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CheckDataScreen extends StatefulWidget {
  @override
  _CheckDataScreenState createState() => _CheckDataScreenState();
}

class _CheckDataScreenState extends State<CheckDataScreen> {
  late Size _size;
  final _refreshController = RefreshController(initialRefresh: false);
  final _searchCtrl = TextEditingController();
  String _selectedStatus = 'Semua';
  _CategoryModel _selectedCategory = _CategoryModel('Semua', 'Semua');
  List<String> _statusList = ['Semua','Belum','Sudah'];
  List<_CategoryModel> _categoryList = [
    _CategoryModel('Semua', 'Semua'),
    _CategoryModel('B', 'Bisnis'),
    _CategoryModel('P', 'Pengurus'),
    _CategoryModel('R', 'Rumah'),
    _CategoryModel('S', 'Sosial'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<GetDataCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cek Data'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: BlocBuilder<GetDataCubit,GetDataState>(
          builder: (context,state){
            if (state is GetDataLoading) {
              return Center(child: CupertinoActivityIndicator(),);
            }
            if (state is GetDataFailure) {
              return SmartRefresher(
                controller: _refreshController,
                child: Center(child: Text(state.msg!),),
                enablePullDown: true,
                header: WaterDropMaterialHeader(),
                onRefresh: (){
                  context.read<GetDataCubit>().fetchData();
                  _refreshController.refreshCompleted();
                },
              );
            }
            if (state is GetDataSuccess) {
              final _data = state.data!;
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: state.hasReachedMax!?false:true,
                onLoading: (){
                  context.read<GetDataCubit>().onLoading(
                    query: _searchCtrl.text,
                    status: _selectedStatus == 'Semua'?null:_selectedStatus == 'Belum'?false:true,
                    category: _selectedCategory.id == 'Semua'?null:_selectedCategory.id,
                  );
                  _refreshController.loadComplete();
                },
                onRefresh: (){
                  context.read<GetDataCubit>().fetchData();
                  _refreshController.refreshCompleted();
                },
                header: WaterDropMaterialHeader(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: _searchCtrl,
                              textInputAction: TextInputAction.search,
                              onFieldSubmitted: (val){
                                context.read<GetDataCubit>().fetchData(
                                  query: _searchCtrl.text,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: 'Cari pengguna..',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: (){
                                    context.read<GetDataCubit>().fetchData(
                                      query: _searchCtrl.text,
                                    );
                                  },
                                ),
                                filled: true,
                                fillColor: BaseColor.grey.withOpacity(0.2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(width: 1,color: BaseColor.grey.withOpacity(0.5))
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(width: 1,color: BaseColor.grey.withOpacity(0.5))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(width: 1,color: BaseColor.grey.withOpacity(0.5))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(width: 1,color: BaseColor.grey.withOpacity(0.5))
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 60,
                              height: 60,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1,color: Colors.black)
                              ),
                              child: Center(
                                child: Icon(FontAwesomeIcons.qrcode),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
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
                      SizedBox(height: 20,),
                      _data.length == 0?
                      Center(
                        child: Text('Tidak ditemukan'),
                      ):
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
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(_item.name!,style: TextStyle(fontSize: 20,),),
                                      SizedBox(height: 8,),
                                      BuildCategory(category: _item.category!,),
                                    ],
                                  ),
                                  Spacer(),
                                  _item.bill == null?
                                  Text('Belum ada tagihan'):BuildPayedStatus(isPayed: _item.bill!.isPayed!)
                                ],
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
            return Container();
          },
        ),
      ),
    );
  }
  void _showFilter(){
    showModalBottomSheet(context: context,shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8))
    ), builder: (context)=>StatefulBuilder(
      builder: (context,myState) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Filter',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  Spacer(),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                      context.read<GetDataCubit>().fetchData(
                        query: _searchCtrl.text,
                        status: _selectedStatus == 'Semua'?null:_selectedStatus == 'Belum'?false:true,
                        category: _selectedCategory.id == 'Semua'?null:_selectedCategory.id,
                      );
                    },
                    child: Text('Atur',style: TextStyle(fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: BaseColor.green,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                  )
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Bayar',style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _statusList.map((e) => GestureDetector(
                      onTap: (){
                        myState((){
                          _selectedStatus = e;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                        child: Text(e,),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _selectedStatus == e?BaseColor.lightBlue:BaseColor.grey)
                        ),
                      ),
                    )).toList(),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Golongan',style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 5,childAspectRatio: 3,
                    ),
                    itemCount: _categoryList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,i){
                      final e = _categoryList[i];
                      return GestureDetector(
                        onTap: (){
                          myState((){
                            _selectedCategory = e;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                          child: Center(child: Text(e.label,)),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _selectedCategory == e?BaseColor.lightBlue:BaseColor.grey)
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        );
      }
    ));
  }
}

class _CategoryModel{
  final String id;
  final String label;

  _CategoryModel(this.id, this.label);
}
