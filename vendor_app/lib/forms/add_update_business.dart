// ignore_for_file: prefer_const_constructors, unused_import, unused_field

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
  String? _imgPath;

  // form key
  final businessFormKey = GlobalKey<FormState>();
  final updateBusinessFormKey = GlobalKey<FormState>();

  // Update fields
  String? updateName;
  String? updateInitialPrice;

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
                  child: SingleChildScrollView(
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
                          stream: cloudService.categoryCollection.snapshots(),
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
                                setState(() {
                                  _selectedCategory = value.toString();
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //     ),
                            //   ),
                            //   onPressed: () {
                            //     imagePickerMethod();
                            //   },
                            //   child: const Text(
                            //     "Select Images",
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(width: 10),
                            // Submit Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                if (businessFormKey.currentState!.validate()) {
                                  cloudService.addBusiness(
                                    context: context,
                                    businessName: businessController.text,
                                    initialPrice: priceController.text,
                                    categoryId: _selectedCategory!,
                                    // image: _image!,
                                  );
                                  businessController.clear();
                                  Get.back();
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
                        // const SizedBox(height: 10),
                        // if (_image != null)
                        //   Container(
                        //     height: 200,
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.black),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Center(
                        //       child: Column(
                        //         children: [
                        //           Expanded(
                        //             child: Image.file(_image!),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
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
                          // updateName = data['cateName'];

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
                              // const SizedBox(height: 10),
                              // if (_image != null)
                              //   Container(
                              //     height: 200,
                              //     decoration: BoxDecoration(
                              //       border: Border.all(color: Colors.black),
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     child: Center(
                              //       child: Column(
                              //         children: [
                              //           Expanded(
                              //             child: Image.file(_image!),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
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
}
