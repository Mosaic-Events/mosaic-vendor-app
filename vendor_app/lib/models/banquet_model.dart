// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'user_model.dart';

class BanquetModel {
  String? id;
  UserModel? owner;
  String? name;
  String? price;
  String? category;
  List<String>? images;
  String? capacity;
  DateTime? registrationDate;

  BanquetModel({
    this.id,
    this.owner,
    this.name,
    this.price,
    this.category,
    this.images,
    this.capacity,
    this.registrationDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'owner': owner?.toMap(),
      'name': name,
      'price': price,
      'category': category,
      'images': images,
      'capacity': capacity,
      'registrationDate': registrationDate?.millisecondsSinceEpoch,
    };
  }

  factory BanquetModel.fromMap(Map<String, dynamic> map) {
    return BanquetModel(
      id: map['id'] != null ? map['id'] as String : null,
      owner: map['owner'] != null
          ? UserModel.fromMap(map['owner'] as Map<String, dynamic>)
          : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      capacity: map['capacity'] != null ? map['capacity'] as String : null,
      registrationDate: map['registrationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['registrationDate'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BanquetModel.fromJson(String source) =>
      BanquetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
