import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamsimas/bloc/get_data/get_data_cubit.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CheckCustomerScreen extends StatefulWidget {
  const CheckCustomerScreen({Key? key}) : super(key: key);

  @override
  State<CheckCustomerScreen> createState() => _CheckCustomerScreenState();
}

class _CheckCustomerScreenState extends State<CheckCustomerScreen> {
  final _refreshController = RefreshController(initialRefresh: false);
  final _searchCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<GetDataCubit>().fetchData(role: 'Pelanggan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cek Pelanggan Terdaftar'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: BlocBuilder<GetDataCubit, GetDataState>(
          builder: (context, state) {
            if (state is GetDataLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is GetDataFailure) {
              return SmartRefresher(
                controller: _refreshController,
                child: Center(
                  child: Text(state.msg!),
                ),
                enablePullDown: true,
                header: WaterDropMaterialHeader(),
                onRefresh: () {
                  context.read<GetDataCubit>().fetchData(role: 'Pelanggan');
                  _refreshController.refreshCompleted();
                },
              );
            }
            if (state is GetDataSuccess) {
              final _data = state.data!;
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: state.hasReachedMax! ? false : true,
                onLoading: () {
                  context.read<GetDataCubit>().onLoading(
                        query: _searchCtrl.text,
                        role: 'Pelanggan'
                      );
                  _refreshController.loadComplete();
                },
                onRefresh: () {
                  context.read<GetDataCubit>().fetchData(role: 'Pelanggan');
                  _refreshController.refreshCompleted();
                },
                header: WaterDropMaterialHeader(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _searchCtrl,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (val) {
                          context.read<GetDataCubit>().fetchData(
                                query: _searchCtrl.text,
                                role: 'Pelanggan'
                              );
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari pengguna..',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              context.read<GetDataCubit>().fetchData(
                                    query: _searchCtrl.text,
                                    role: 'Pelanggan'
                                  );
                            },
                          ),
                          filled: true,
                          fillColor: BaseColor.grey.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: BaseColor.grey.withOpacity(0.5),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: BaseColor.grey.withOpacity(0.5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: BaseColor.grey.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: BaseColor.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _data.length == 0
                          ? Center(
                              child: Text('Tidak ditemukan'),
                            )
                          : ListView.builder(
                              itemCount: _data.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, i) {
                                final _item = _data[i];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        'https://res.cloudinary.com/febryar/image/upload/v1598796112/no_avatar_weaizx.jpg',
                                      ),
                                    ),
                                    title: Text(
                                      _item.name!,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Text(_item.address!),
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
}
