// ignore_for_file: prefer_const_constructors, unused_import, unused_field, prefer_final_fields
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/cloud_services.dart';

class AddOrUpdateBanquet extends StatefulWidget {
  const AddOrUpdateBanquet({super.key});

  @override
  State<AddOrUpdateBanquet> createState() => _AddOrUpdateBanquetState();
}

class _AddOrUpdateBanquetState extends State<AddOrUpdateBanquet> {
  final formKey = GlobalKey<FormState>();
  TextEditingController banquetNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController capacityController = TextEditingController();

  // images
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _selectedFiles = [];
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  List<String> _arrImagesUrls = [];
  int uploadedImages = 0;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Banquet"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: isUploading
              ? showLoading()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: banquetNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{1,}$');
                          if (value!.isEmpty) {
                            return "Enter banquet Name";
                          }
                          if (!regex.hasMatch(value)) {
                            return "Enter minimum 3 Character";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          banquetNameController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.business),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Banquet Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{1,}$');
                          if (value!.isEmpty) {
                            return "Please Enter Price";
                          }
                          if (!regex.hasMatch(value)) {
                            return "Enter minimum 3 Character";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          priceController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.currency_rupee),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Initial Price",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: capacityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{1,}$');
                          if (value!.isEmpty) {
                            return "Please Enter Price";
                          }
                          if (!regex.hasMatch(value)) {
                            return "Enter minimum 3 Character";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          capacityController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.people),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Capaciy of people",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // select images
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              selectImages();
                            },
                            child: const Text(
                              "Select Images",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // Submit Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                uploadFunction(_selectedFiles).then((value) {
                                  cloudService
                                      .addBanquet(
                                    name: banquetNameController.text.trim(),
                                    capacity: capacityController.text.trim(),
                                    price: priceController.text.trim(),
                                    images: _arrImagesUrls,
                                  )
                                      .then((value) {
                                    banquetNameController.clear();
                                    priceController.clear();
                                    capacityController.clear();
                                    _selectedFiles.clear();
                                    Get.back();
                                  });
                                });
                              }
                            },
                            child: const Text(
                              "Add Businesss",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _selectedFiles.isEmpty
                          ? const Text('No Image Selected')
                          : GridView.builder(
                              shrinkWrap: true,
                              itemCount: _selectedFiles.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.file(
                                    File(_selectedFiles[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              })
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget showLoading() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircularProgressIndicator(),
        SizedBox(height: 15),
        Text('Uploading: $uploadedImages/${_selectedFiles.length}'),
      ]),
    );
  }

  Future<void> selectImages() async {
    if (_selectedFiles.isNotEmpty) {
      _selectedFiles.clear();
    }
    try {
      final List<XFile>? imgs = await _imagePicker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
    } catch (e) {
      log('Something went wrong: $e');
    }
    setState(() {});
  }

  Future<String> uploadImage(XFile image) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final imageId = 'ban_${DateTime.now().millisecondsSinceEpoch}';
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('business_images')
        .child(userId)
        .child(imageId);

    UploadTask uploadTask = reference.putFile(File(image.path));
    await uploadTask.whenComplete(() async {
      String dd = await reference.getDownloadURL();

      log(dd);
      setState(() {
        uploadedImages++;
        if (uploadedImages == _selectedFiles.length) {
          isUploading = false;
          uploadedImages = 0;
        }
      });
    });

    return await reference.getDownloadURL();
  }

  Future<void> uploadFunction(List<XFile> images) async {
    setState(() {
      isUploading = true;
    });
    for (int i = 0; i < images.length; i++) {
      var imgUrl = await uploadImage(images[i]);
      _arrImagesUrls.add(imgUrl.toString());
    }
  }
}
