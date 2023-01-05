import 'package:pamsimas/model/history_model.dart';

class UserModel {
  String? uid;
  String? address;
  String? category;
  String? name;
  String? role;
  String? username;
  String? password;
  BillModel? bill;
  String? email;

  UserModel({
    this.uid,
    this.address,
    this.category,
    this.name,
    this.role,
    this.bill,
    this.password,
    this.username,
    this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      address: json['address'],
      category: json['category'],
      role: json['role'],
      uid: json['uid'],
      username: json['username'] == null ? null : json['username'],
      password: json['password'],
      bill: json['bill'] == null ? null : BillModel.fromMap(json['bill']),
      email: json['email'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'address': address,
        'category': category,
        'role': role,
        'bill': bill?.toMap()
      };
}
