import 'package:flutter/material.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/routes.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserAccountScreen extends StatefulWidget {
  final UserModel data;

  const UserAccountScreen({Key? key,required this.data}) : super(key: key);
  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  UserModel get user => widget.data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun pengguna'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: QrImage(
                  data: user.uid!,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              SizedBox(height: 12,),
              Text('Detail akun',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Row(
                children: [
                  Text('ID Pengguna',style: TextStyle(color: BaseColor.grey),),
                  Spacer(),
                  Text(user.uid!),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Text('Nama',style: TextStyle(color: BaseColor.grey),),
                  Spacer(),
                  Text(user.name!),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Text('Username',style: TextStyle(color: BaseColor.grey),),
                  Spacer(),
                  Text(user.username ?? user.uid!),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Text('Password',style: TextStyle(color: BaseColor.grey),),
                  Spacer(),
                  Text(user.password!),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Text('Role',style: TextStyle(color: BaseColor.grey),),
                  Spacer(),
                  Text(user.role!),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Text('Kategori',style: TextStyle(color: BaseColor.grey),),
                  Spacer(),
                  Text(user.category!),
                ],
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: ()=>Navigator.pushNamed(context, rDownloadUserAccount,arguments: user),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Center(child: Text('Download akun pengguna ini',style: TextStyle(color: BaseColor.red),),),
                  decoration: BoxDecoration(
                    color: BaseColor.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1,color: BaseColor.red,
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
