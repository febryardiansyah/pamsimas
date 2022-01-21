import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamsimas/bloc/get_history_bill/get_history_bill_cubit.dart';
import 'package:pamsimas/components/status_card.dart';
import 'package:pamsimas/helpers/routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HistoryBillScreen extends StatefulWidget {

  @override
  _HistoryBillScreenState createState() => _HistoryBillScreenState();
}

class _HistoryBillScreenState extends State<HistoryBillScreen> {
  final _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    context.read<GetHistoryBillCubit>().fetchHistory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Riwayat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: BlocBuilder<GetHistoryBillCubit,GetHistoryBillState>(
          builder: (context,state){
            if (state is GetHistoryBillLoading) {
              return Center(child: CupertinoActivityIndicator(),);
            }
            if (state is GetHistoryBillFailure) {
              return Center(child: Text(state.msg!),);
            }
            if (state is GetHistoryBillSuccess) {
              final _data = state.data!;
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: state.hasReachedMax!?false:true,
                onLoading: (){
                  context.read<GetHistoryBillCubit>().onLoading();
                  _refreshController.loadComplete();
                },
                onRefresh: (){
                  context.read<GetHistoryBillCubit>().fetchHistory();
                  _refreshController.refreshCompleted();
                },
                header: WaterDropMaterialHeader(),
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context,i){
                    final _item = _data[i].bill!;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: StatusCard(
                        data: _item,
                        onTap: ()=>Navigator.pushNamed(context, rInvoice,arguments: _data[i]),
                      ),
                    );
                  },
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
