import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel{
  String? uid;
  List<BillModel>? bills;

  HistoryModel({this.uid, this.bills});

  factory HistoryModel.fromMap(Map<String,dynamic>json){
    return HistoryModel(
      uid: json['uid'],
      bills: json['bills'] == null?null:List<BillModel>.from(json['bills'].map((x)=>BillModel.fromMap(x))),
    );
  }

  Map<String,dynamic> toMap()=>{
    'uid': uid,
    'bills': List<BillModel>.from(bills!.map((e) => BillModel.fromMap(e.toMap())))
  };
}

class BillModel {
  int? currentBill;
  String? month;
  bool? isPayed;
  String? year;
  String? usage;
  DateTime? createdAt;

  BillModel({this.currentBill, this.month, this.isPayed,this.year,this.usage,this.createdAt});

  factory BillModel.fromMap(Map<String,dynamic>json){
    return BillModel(
      currentBill: json['currentBill'] == null?null:json['currentBill'],
      month: json['month'] == null?null:json['month'],
      isPayed: json['isPayed'] == null?null:json['isPayed'],
      year: json['year'] == null?null:json['year'],
      usage: json['usage'] == null?null:json['usage'],
      // createdAt: json['createdAt'] == null?null:DateTime.parse(json['createdAt'])
    );
  }

  Map<String,dynamic> toMap()=>{
    'currentBill':currentBill,
    'month':month,
    'isPayed':isPayed,
    'year':year,
    'usage':usage,
    'createdAt':createdAt
  };
}