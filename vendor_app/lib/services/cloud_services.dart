import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/business_model.dart';
import '../models/category_model.dart';

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

  // GET: Category By ID
  getCategoryById({required String cateId}) =>
      categoryCollection.doc(cateId).get();

  // GET: Business By ID
  getBusinessById({required String businessId}) =>
      businessCollection.doc(businessId).get();

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
      log("Category $categoryName Added");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error occured: $error");
    });
  }

  // UPDATE: Category to firestore
  Future updateCategory(
      {required String cateId, required String categoryName}) async {
    await categoryCollection.doc(cateId).update({
      'cateName': categoryName,
    }).whenComplete(() {
      Fluttertoast.showToast(msg: "Category Updated");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error occured: $error");
    });
  }

  // ADD: Business to firestore
  Future addBusiness({
    required BuildContext context,
    required String businessName,
    required String initialPrice,
    required String categoryId,
    // List<String>? images,
  }) async {
    final businessId =
        'busi_${DateTime.now().millisecondsSinceEpoch}'; // For unique id

    // calling our cate_model
    BusinessModel businessModel = BusinessModel();
    businessModel.owner = _auth.currentUser!.uid;
    businessModel.businessId = businessId;
    businessModel.businessName = businessName;
    businessModel.initialPrice = initialPrice;
    businessModel.businessCategory = categoryId;
    businessModel.images = [];
    businessModel.joiningDate = DateTime.now();

    await businessCollection
        .doc(businessId)
        .set(businessModel.toMap())
        .whenComplete(() {
      // UploadImage.uploadBusinessImages(context, businessId, image);
    }).catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }

  // UPDATE: Business to firestore
  Future updateBusiness({
    required String businessId,
    required String businessName,
    required String initialPrice,
    required String businessCategory,
  }) async {
    await businessCollection.doc(businessId).update({
      'businessName': businessName,
      'businessCategory': businessCategory,
      'initialPrice': initialPrice,
    }).whenComplete(() {
      Fluttertoast.showToast(msg: "Business Updated");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error occured: $error");
    });
  }
}
