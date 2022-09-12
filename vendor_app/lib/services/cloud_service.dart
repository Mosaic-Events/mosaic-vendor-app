import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/business_model.dart';
import '../models/category_model.dart';
import '../utils/upload_image.dart';

class CloudService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GET: Users Collection
  CollectionReference get usersCollection =>
      _firebaseFirestore.collection('users');

  // GET: User By ID
  getUserById({required String uid}) => usersCollection.doc(uid).get();

  // GET: Category Collection
  CollectionReference get categoryCollection =>
      _firebaseFirestore.collection('categories');

  // GET: Business Collection
  CollectionReference get businessCollection =>
      _firebaseFirestore.collection('businesses');
  // GET: Business Collection
  Query<Map<String, dynamic>> get businesCollection =>
      _firebaseFirestore.collectionGroup("collectionPath");

  // GET: Category By ID
  getCategoryById({required String cateId}) =>
      categoryCollection.doc(cateId).get();

  // ADD: Category to firestore
  Future addCategory(String categoryName) async {
    final cateId =
        'cate_${DateTime.now().millisecondsSinceEpoch}'; // For unique id

    // calling our cate_model
    CategoryModel categoryModel = CategoryModel();
    categoryModel.cateId = cateId;
    categoryModel.cateName = categoryName;

    await categoryCollection
        .doc(cateId)
        .set(categoryModel.toMap())
        .whenComplete(() {
      Fluttertoast.showToast(msg: "Category $categoryName Added");
    });
  }

  // UPDATE: Category to firestore
  Future updateCategory(
      {required String cateId, required String categoryName}) async {
    await categoryCollection.doc(cateId).update({
      'cate_name': categoryName,
    }).whenComplete(() {
      Fluttertoast.showToast(msg: "Category Updated");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error occured: $error");
    });
  }

  // ADD: Business to firestore
  Future addBusiness(
      {required String businessName,
      required String initialPrice,
      required String categoryId,
      required BuildContext context,
      required File image}) async {
    final businessId =
        'busi_${DateTime.now().millisecondsSinceEpoch}'; // For unique id

    // calling our cate_model
    BusinessModel businessModel = BusinessModel();
    businessModel.owner = _auth.currentUser!.uid;
    businessModel.busiId = businessId;
    businessModel.busiName = businessName;
    businessModel.initialPrice = initialPrice;
    businessModel.busiCategory = categoryId;
    businessModel.joiningDate = DateTime.now();

    await businessCollection
        .doc(businessId)
        .set(businessModel.toMap())
        .whenComplete(() {
      UploadImage.uploadBusinessImages(context, businessId, image);
    }).catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }
}
