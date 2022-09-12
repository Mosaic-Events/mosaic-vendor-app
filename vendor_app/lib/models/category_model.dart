// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

class CategoryModel {
  String? cateId;
  String? cateName;
  CategoryModel({
    this.cateId,
    this.cateName,
  });

  /*CategoryModel copyWith({
    String? cateId,
    String? cateName,
  }) {
    return CategoryModel(
      cateId: cateId ?? this.cateId,
      cateName: cateName ?? this.cateName,
    );
  }
  */

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cateId': cateId,
      'cateName': cateName,
    };
  }
/*
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      cateId: map['cateId'] != null ? map['cateId'] as String : null,
      cateName: map['cateName'] != null ? map['cateName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryModel(cateId: $cateId, cateName: $cateName)';

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.cateId == cateId &&
      other.cateName == cateName;
  }

  @override
  int get hashCode => cateId.hashCode ^ cateName.hashCode;
  */
}