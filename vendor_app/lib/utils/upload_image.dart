import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage {
  // Upload Profile Image
  static uploadProfileImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    File? image;
    final imagePicker = ImagePicker();
    String? downloadURL;

    final selectedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (selectedImage != null) {
      image = File(selectedImage.path);
    } else {
      Fluttertoast.showToast(msg: "No File selected");
    }

    final imgId =
        DateTime.now().millisecondsSinceEpoch.toString(); // For unique name

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(userId)
        .child('profile_pic')
        .child("img_$imgId");

    await reference.putFile(image!);
    downloadURL = await reference.getDownloadURL();

    // cloud firestore
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .update({'profileUrl': downloadURL})
        .whenComplete(() => {
              currentUser!.updatePhotoURL(downloadURL),
              Fluttertoast.showToast(msg: "Image Uploaded"),
            })
        .catchError((onError) {
          Fluttertoast.showToast(msg: onError);
        });
  }

  // Upload Carousel Banner
  static uploadCarouselBanner(BuildContext context) async {
    File? banner;
    final imagePicker = ImagePicker();
    String? downloadURL;

    final selectedBanner = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (selectedBanner != null) {
      banner = File(selectedBanner.path);
    } else {
      Fluttertoast.showToast(msg: "No File selected");
    }

    final bannerId =
        'ban_${DateTime.now().millisecondsSinceEpoch}'; // For unique name

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('carousel_banners')
        .child(bannerId);

    await reference.putFile(banner!);
    downloadURL = await reference.getDownloadURL();

    // cloud firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection("carousel_banners").doc(bannerId).set({
      'id': bannerId,
      'carousel_banners_url': downloadURL,
    }).whenComplete(() {
      Fluttertoast.showToast(msg: "Banner Added :)");
    });
  }

  // Upload Business Images
  static uploadBusinessImages(BuildContext context, businessId, image) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final imageId =
        'ban_${DateTime.now().millisecondsSinceEpoch}'; // For unique name
    String? downloadURL;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('business_images')
        .child(userId)
        .child(businessId)
        .child(imageId);

    await reference.putFile(image!);
    downloadURL = await reference.getDownloadURL();

    // cloud firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection("businesses")
        .doc(businessId)
        .update({'images': [downloadURL]}).whenComplete(() {
      Fluttertoast.showToast(msg: "Business Added :)");
    }).catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }
}
