import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:vendor_app/forms/add_update_category.dart';

import '../services/cloud_services.dart';

class CategorySettingScreen extends StatefulWidget {
  const CategorySettingScreen({Key? key}) : super(key: key);

  @override
  State<CategorySettingScreen> createState() => _CategorySettingScreenState();
}

class _CategorySettingScreenState extends State<CategorySettingScreen> {
  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Category'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cloudService.categoryCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['cateName']),
                    subtitle: Text(snapshot.data!.docs[index]['cateId']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddOrUpdateCategory(
                                    cateId: snapshot.data!.docs[index]
                                        ['cateId'],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                            )),
                        IconButton(
                            onPressed: () {
                              deleteCategory(
                                  snapshot.data!.docs[index]['cateId']);
                            },
                            icon: const Icon(
                              Icons.delete,
                            ))
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                "Sorry, There is no data right now.\nPlease add some categories first.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddOrUpdateCategory()),
            );
          },
          child: const Icon(Icons.add)),
    );
  }

  deleteCategory(cateId) {
    final cloudService = Provider.of<CloudService>(context, listen: false);
    cloudService.categoryCollection.doc(cateId).delete().whenComplete(() {
      Fluttertoast.showToast(msg: "Category Deleted");
    });
  }
}
