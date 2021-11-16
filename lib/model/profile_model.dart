class ProfileModel{
  String? uid;
  String? address;
  String? category;
  String? name;
  String? role;

  ProfileModel({this.uid, this.address, this.category, this.name, this.role});

  factory ProfileModel.fromMap(Map<String,dynamic>json){
    return ProfileModel(
      name: json['name'],
      address: json['address'],
      category: json['category'],
      role: json['role'],
      uid: json['uid']
    );
  }
}