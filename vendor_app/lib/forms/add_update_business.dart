// ignore_for_file: prefer_const_constructors, unused_import, unused_field, prefer_final_fields

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/services/auth_service.dart';

import '../services/cloud_services.dart';

class AddOrUpdateBusiness extends StatefulWidget {
  final String? businessId;
  const AddOrUpdateBusiness({Key? key, this.businessId}) : super(key: key);

  @override
  State<AddOrUpdateBusiness> createState() => _AddOrUpdateBusinessState();
}

class _AddOrUpdateBusinessState extends State<AddOrUpdateBusiness> {
  final TextEditingController businessController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? _selectedCategory;

  // form key
  final businessFormKey = GlobalKey<FormState>();
  final updateBusinessFormKey = GlobalKey<FormState>();

  // Update fields
  String? updateName;
  String? updateInitialPrice;

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
          title: Text("Register Business"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.businessId == null
              ? // ADD: Business Form
              Form(
                  key: businessFormKey,
                  child: isUploading
                      ? showLoading()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              // Business Name
                              TextFormField(
                                autofocus: true,
                                controller: businessController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{1,}$');
                                  if (value!.isEmpty) {
                                    return "Enter business Name";
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return "Enter minimum 3 Character";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  businessController.text = value!;
                                },
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.business),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Business Name",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Initial Price
                              TextFormField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{1,}$');
                                  if (value!.isEmpty) {
                                    return "Enter Initial Price";
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
                              DropdownButtonHideUnderline(
                                  child: StreamBuilder<QuerySnapshot>(
                                stream:
                                    cloudService.categoryCollection.snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong!");
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  // fetching data
                                  final List cateList = [];
                                  snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map categoryDate = document.data() as Map;
                                    cateList.add(categoryDate['cateName']);
                                  }).toList();
                                  return DropdownButtonFormField(
                                    hint: Text("Select Category"),
                                    value: _selectedCategory,
                                    items: cateList
                                        .map(
                                          (e) => DropdownMenuItem(
                                              value: e, child: Text(e)),
                                        )
                                        .toList(),
                                    onChanged: (newCategory) {
                                      setState(() {
                                        _selectedCategory =
                                            newCategory.toString();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 15),
                                      labelText: "Category",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              )),

                              const SizedBox(height: 10),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // select images
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (businessFormKey.currentState!
                                          .validate()) {
                                        uploadFunction(_selectedFiles)
                                            .then((value) {
                                          cloudService
                                              .addBusiness(
                                            context: context,
                                            businessName:
                                                businessController.text,
                                            initialPrice: priceController.text,
                                            categoryId: _selectedCategory!,
                                            images: _arrImagesUrls,
                                          )
                                              .then((value) {
                                            businessController.clear();
                                            priceController.clear();
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
                                  ? Text('No Image Selected')
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: _selectedFiles.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
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
                )
              : // UPDATE: Business Form
              Form(
                  key: updateBusinessFormKey,
                  child: FutureBuilder<DocumentSnapshot>(
                      future: cloudService.getBusinessById(
                          businessId: widget.businessId!),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return const Text("Document does not exist");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          updateName = data['businessName'];
                          updateInitialPrice = data['initialPrice'];
                          _selectedCategory = data['businessCategory'];

                          return Column(
                            children: [
                              // Business Name
                              TextFormField(
                                initialValue: updateName,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{1,}$');
                                  if (value!.isEmpty) {
                                    return "Enter business Name";
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return "Enter minimum 3 Character";
                                  }
                                  return null;
                                },
                                onChanged: (newValue) {
                                  updateName = newValue;
                                },
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.business),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Business Name",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Initial Price
                              TextFormField(
                                initialValue: updateInitialPrice,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{1,}$');
                                  if (value!.isEmpty) {
                                    return "Enter Initial Price";
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return "Enter minimum 3 Character";
                                  }
                                  return null;
                                },
                                onChanged: (newValue) {
                                  updateInitialPrice = newValue;
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
                              DropdownButtonHideUnderline(
                                  child: StreamBuilder<QuerySnapshot>(
                                stream:
                                    cloudService.categoryCollection.snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong!");
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  // fetching data
                                  final List cateList = [];
                                  snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map categoryDate = document.data() as Map;
                                    cateList.add(categoryDate['cateName']);
                                  }).toList();
                                  return DropdownButtonFormField(
                                    hint: Text("Select Category"),
                                    value: _selectedCategory,
                                    items: cateList
                                        .map(
                                          (e) => DropdownMenuItem(
                                              value: e, child: Text(e)),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      _selectedCategory = value.toString();
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 15),
                                      labelText: "Category",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              )),

                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Images
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      // imagePickerMethod();
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
                                  const SizedBox(width: 10),
                                  // Submit Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (updateBusinessFormKey.currentState!
                                          .validate()) {
                                        cloudService.updateBusiness(
                                            businessId: widget.businessId!,
                                            businessName: updateName!,
                                            initialPrice: updateInitialPrice!,
                                            businessCategory:
                                                _selectedCategory!);
                                        setState(() {
                                          updateName = "";
                                          updateInitialPrice = "";
                                        });
                                      }
                                      Get.back();
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
                            ],
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
        ));
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
