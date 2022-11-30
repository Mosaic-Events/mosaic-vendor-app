import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/models/user_model.dart';
import 'package:vendor_app/screens/service_detail_screen.dart';

import '../forms/add_update_business.dart';
import '../services/cloud_services.dart';
import '../utils/my_card.dart';

class BusinessSettingScreen extends StatelessWidget {
  const BusinessSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Business'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cloudService.businessCollection
            .where('owner.uid', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, index) {
                  final name =
                      snapshot.data!.docs[index]['name'];
                  final owner = snapshot.data!.docs[index]['owner'];
                  final UserModel user = UserModel.fromMap(owner);
                  final id = snapshot.data!.docs[index]['id'];
                  final price =
                      snapshot.data!.docs[index]['price'];
                  final imageUrl = snapshot.data!.docs[index]['images'];
                  return InkWell(
                    onTap: () {
                      Get.to(() => ServiceDetailScreen(
                            serviceId: id,
                          ));
                    },
                    child: MyCard(
                      title: name,
                      price: price,
                      description: user.fullname,
                      businessId: id,
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
          Get.to(() => const AddOrUpdateBusiness());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
