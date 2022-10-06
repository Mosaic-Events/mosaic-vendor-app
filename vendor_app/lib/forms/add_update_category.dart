import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../services/cloud_services.dart';

class AddOrUpdateCategory extends StatelessWidget {
  final String? cateId;
  AddOrUpdateCategory({Key? key, this.cateId}) : super(key: key);

  // Controller
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);

    String? updateName;

    // form key
    final formKey = GlobalKey<FormState>();
    final updateCategoryFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: cateId == null
            ? // ADD: Category Form
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: categoryController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{1,}$');
                        if (value!.isEmpty) {
                          return "Please enter category";
                        }
                        if (!regex.hasMatch(value)) {
                          return "Enter minimum 3 Character";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        categoryController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Category Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          cloudService.addCategory(categoryController.text);
                          categoryController.clear();
                          Get.back();
                        }
                      },
                      child: const Text(
                        "ADD",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : // UPDATE: Category Form
            Form(
                key: updateCategoryFormKey,
                child: FutureBuilder<DocumentSnapshot>(
                    future: cloudService.getCategoryById(cateId: cateId!),
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
                        updateName = data['cateName'];
                        return Column(
                          children: [
                            TextFormField(
                              autofocus: true,
                              initialValue: updateName,
                              keyboardType: TextInputType.name,
                              validator: (newName) {
                                RegExp regex = RegExp(r'^.{1,}$');
                                if (newName!.isEmpty) {
                                  return "Please enter category";
                                }
                                if (!regex.hasMatch(newName)) {
                                  return "Enter minimum 3 Character";
                                }
                                return null;
                              },
                              onChanged: (newName) {
                                updateName = newName;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.category),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                if (updateCategoryFormKey.currentState!
                                    .validate()) {
                                  cloudService.updateCategory(
                                      cateId: cateId!,
                                      categoryName: updateName!);
                                  updateName = "";
                                }
                                Get.back();
                              },
                              child: const Text(
                                "UPDATE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
      ),
    );
  }
}
