import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamsimas/bloc/get_user_by_uid/get_user_by_uid_cubit.dart';
import 'package:pamsimas/helpers/base_color.dart';

class ScanResultScreen extends StatefulWidget {
  final String? uid;

  const ScanResultScreen({Key? key, this.uid}) : super(key: key);

  @override
  _ScanResultScreenState createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetUserByUidCubit>().fetchUserByUid(widget.uid!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseColor.lightBlue,
        title: Text('Pengguna'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
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
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_data.name!),
                    Text(_data.address!),
                    Text(_data.category!),
                  ],
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
