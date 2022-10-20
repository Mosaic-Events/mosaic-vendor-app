import 'package:vendor_app/models/user_model.dart';

class BusinessModel {
  String? businessId;
  String? businessName;
  String? initialPrice;
  String? businessCategory;
  List<String>? images;
  DateTime? joiningDate;
  UserModel? owner;
  BusinessModel({
    this.owner,
    this.businessId,
    this.businessName,
    this.initialPrice,
    this.businessCategory,
    this.joiningDate,
    this.images,
  });
  // location

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'owner': owner?.toMap(),
      'businessId': businessId,
      'businessName': businessName,
      'initialPrice': initialPrice,
      'businessCategory': businessCategory,
      'images': images,
      'joiningDate': joiningDate?.millisecondsSinceEpoch,
    };
  }

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      owner: map['owner'],
      businessId: map['businessId'],
      businessName: map['businessName'],
      initialPrice: map['initialPrice'],
      businessCategory: map['businessCategory'],
      joiningDate: map['joiningDate'],
      images: map['images'],
    );
  }
}
