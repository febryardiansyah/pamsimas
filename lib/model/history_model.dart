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
  String? id;
  int? currentBill;
  int? lastBill;
  int? currentUsage;
  int? lastUsage;
  int? totalPaid;
  String? month;
  bool? isPayed;
  String? year;
  DateTime? createdAt;

  BillModel({
    this.currentBill, this.month, this.isPayed,this.year,this.currentUsage,this.createdAt,this.id,this.totalPaid,
    this.lastBill,this.lastUsage,
});

  factory BillModel.fromMap(Map<String,dynamic>json){
    return BillModel(
      id: json['id'] == null?null:json['id'],
      currentBill: json['currentBill'] == null?null:json['currentBill'],
      totalPaid: json['totalPaid'] == null?null:json['totalPaid'],
      month: json['month'] == null?null:json['month'],
      isPayed: json['isPayed'] == null?null:json['isPayed'],
      year: json['year'] == null?null:json['year'],
      currentUsage: json['currentUsage'] == null?null:json['currentUsage'],
      lastBill: json['lastBill'] == null?null:json['lastBill'],
      lastUsage: json['lastUsage'] == null?null:json['lastBill']
      // createdAt: json['createdAt'] == null?null:DateTime.parse(json['createdAt'])
    );
  }

  Map<String,dynamic> toMap()=>{
    'id':id,
    'currentBill':currentBill,
    'month':month,
    'isPayed':isPayed,
    'year':year,
    'currentUsage':currentUsage,
    'createdAt':createdAt,
    'totalPaid':totalPaid,
    'lastBill':lastBill,
    'lastUsage':lastUsage,
  };
}