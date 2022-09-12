// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

class BusinessModel {
  String? owner;
  String? busiId;
  String? busiName;
  String? initialPrice;
  String? busiCategory;
  List? images;
  DateTime? joiningDate;
  BusinessModel({
    this.owner,
    this.busiId,
    this.busiName,
    this.initialPrice,
    this.busiCategory,
    this.joiningDate,
    this.images,
  });
  // location

  /* BusinessModel copyWith({
    UserModel? owner,
    String? busiId,
    String? busiName,
    num? initialPrice,
    CategoryModel? busiCategory,
    DateTime? joiningDate,
  }) {
    return BusinessModel(
      owner: owner ?? this.owner,
      busiId: busiId ?? this.busiId,
      busiName: busiName ?? this.busiName,
      initialPrice: initialPrice ?? this.initialPrice,
      busiCategory: busiCategory ?? this.busiCategory,
      joiningDate: joiningDate ?? this.joiningDate,
    );
  }
*/
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'owner': owner,
      'busiId': busiId,
      'busiName': busiName,
      'initialPrice': initialPrice,
      'busiCategory': busiCategory,
      'images': images,
      'joiningDate': joiningDate?.millisecondsSinceEpoch,
    };
  }
/*
  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      owner: map['owner'] != null ? UserModel.fromMap(map['owner'] as Map<String,dynamic>) : null,
      busiId: map['busiId'] != null ? map['busiId'] as String : null,
      busiName: map['busiName'] != null ? map['busiName'] as String : null,
      initialPrice: map['initialPrice'] != null ? map['initialPrice'] as num : null,
      busiCategory: map['busiCategory'] != null ? CategoryModel.fromMap(map['busiCategory'] as Map<String,dynamic>) : null,
      joiningDate: map['joiningDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['joiningDate'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusinessModel.fromJson(String source) => BusinessModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BusinessModel(owner: $owner, busiId: $busiId, busiName: $busiName, initialPrice: $initialPrice, busiCategory: $busiCategory, joiningDate: $joiningDate)';
  }

  @override
  bool operator ==(covariant BusinessModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.owner == owner &&
      other.busiId == busiId &&
      other.busiName == busiName &&
      other.initialPrice == initialPrice &&
      other.busiCategory == busiCategory &&
      other.joiningDate == joiningDate;
  }

  @override
  int get hashCode {
    return owner.hashCode ^
      busiId.hashCode ^
      busiName.hashCode ^
      initialPrice.hashCode ^
      busiCategory.hashCode ^
      joiningDate.hashCode;
  }
  */
}
