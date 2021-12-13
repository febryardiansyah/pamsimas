import 'package:flutter/material.dart';
import 'package:pamsimas/helpers/base_color.dart';

class BuildPayedStatus extends StatelessWidget {
  final bool isPayed;

  const BuildPayedStatus({Key? key,required this.isPayed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      isPayed ? 'Sudah Bayar':'Belum Bayar',
      style: TextStyle(color: isPayed?BaseColor.greenDeep:BaseColor.red,fontSize: 17),
    );
  }
}
