class UserModel{
  String? uid;
  String? address;
  String? category;
  String? name;
  String? role;

  UserModel({this.uid, this.address, this.category, this.name, this.role});

  factory UserModel.fromMap(Map<String,dynamic>json){
    return UserModel(
      name: json['name'],
      address: json['address'],
      category: json['category'],
      role: json['role'],
      uid: json['uid']
    );
  }
}