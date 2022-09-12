// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../forms/add_update_business.dart';
import '../services/cloud_services.dart';
import '../utils/my_card.dart';
import 'service_detail_screen.dart';

class BusinessSettingScreen extends StatelessWidget {
  const BusinessSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Business'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cloudService.businessCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, index) {
                  final businessName =
                      snapshot.data!.docs[index]['businessName'];
                  final owner = snapshot.data!.docs[index]['owner'];
                  final businessId = snapshot.data!.docs[index]['businessId'];
                  final initialPrice =
                      snapshot.data!.docs[index]['initialPrice'];
                  final imageUrl = snapshot.data!.docs[index]['images'];
                  return InkWell(
                    onTap: () {
                      log("Service $index pressed");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ServiceDetailScreen(
                                    serviceTitle: "Service Title",
                                  )));
                    },
                    child: MyCard(
                      title: businessName,
                      price: initialPrice,
                      description: owner,
                      businessId: businessId,
                      imageUrl: imageUrl,
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                "Sorry, There is no data right now.\nPlease add some data first.",
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddOrUpdateBusiness()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
