import 'dart:convert';

import 'user_model.dart';



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
      'businessId': businessId,
      'businessName': businessName,
      'initialPrice': initialPrice,
      'businessCategory': businessCategory,
      'images': images,
      'joiningDate': joiningDate?.millisecondsSinceEpoch,
      'owner': owner?.toMap(),
    };
  }

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      businessId:
          map['businessId'] != null ? map['businessId'] as String : null,
      businessName:
          map['businessName'] != null ? map['businessName'] as String : null,
      initialPrice:
          map['initialPrice'] != null ? map['initialPrice'] as String : null,
      businessCategory: map['businessCategory'] != null
          ? map['businessCategory'] as String
          : null,
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      joiningDate: map['joiningDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['joiningDate'] as int)
          : null,
      owner: map['owner'] != null
          ? UserModel.fromMap(map['owner'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusinessModel.fromJson(String source) =>
      BusinessModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
