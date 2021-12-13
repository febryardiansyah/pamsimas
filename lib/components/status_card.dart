import 'package:flutter/material.dart';
import 'package:pamsimas/components/build_payed_status.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/history_model.dart';

class StatusCard extends StatelessWidget {
  final Function()? onTap;
  final BillModel? data;

  const StatusCard({Key? key, this.onTap, this.data}) : super(key: key);

  bool get _isPayed => data == null?false:data!.isPayed!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              _isPayed?BaseColor.green.withOpacity(0.5):BaseColor.red.withOpacity(0.5),
              BaseColor.white,
              BaseColor.white
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 2,
              color: _isPayed?BaseColor.green:BaseColor.red,
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${data!.month} ${data!.year}',style: TextStyle(fontSize: 20,color: BaseColor.grey),),
                SizedBox(height: 5,),
                Text(Helper.formatCurrency(data!.currentBill!),style: TextStyle(fontSize: 17),)
              ],
            ),
            Spacer(),
            BuildPayedStatus(isPayed: _isPayed)
          ],
        ),
      ),
    );
  }
}
