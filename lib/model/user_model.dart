class UserModel{
  String? uid;
  String? address;
  String? category;
  String? name;
  String? role;
  int? currentBill;
  String? month;
  bool? isPayed;
  String? year;

  UserModel({this.uid, this.address, this.category, this.name, this.role,this.month,this.currentBill,this.isPayed,this.year});

  factory UserModel.fromMap(Map<String,dynamic>json){
    return UserModel(
      name: json['name'],
      address: json['address'],
      category: json['category'],
      role: json['role'],
      uid: json['uid'],
      currentBill: json['currentBill'] == null?null:json['currentBill'],
      month: json['month'] == null?null:json['month'],
      isPayed: json['isPayed'] == null?null:json['isPayed'],
      year: json['year'] == null?null:json['year'],
    );
  }

  Map<String,dynamic> toMap()=>{
    'uid':uid,
    'name':name,
    'address':address,
    'category':category,
    'role':role,
    'currentBill':currentBill,
    'month':month,
    'isPayed':isPayed,
    'year':year,
  };
}