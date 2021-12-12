import 'package:pamsimas/model/history_model.dart';

class UserModel{
  String? uid;
  String? address;
  String? category;
  String? name;
  String? role;
  BillModel? bill;

  UserModel({this.uid, this.address, this.category, this.name, this.role,this.bill});

  factory UserModel.fromMap(Map<String,dynamic>json){
    return UserModel(
      name: json['name'],
      address: json['address'],
      category: json['category'],
      role: json['role'],
      uid: json['uid'],
      bill: json['bill'] == null?null:BillModel.fromMap(json['bill']),
    );
  }

  Map<String,dynamic> toMap()=>{
    'uid':uid,
    'name':name,
    'address':address,
    'category':category,
    'role':role,
  };
}