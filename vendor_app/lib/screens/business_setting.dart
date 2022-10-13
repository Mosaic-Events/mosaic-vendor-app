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
                  final businessName =
                      snapshot.data!.docs[index]['businessName'];
                  final owner = snapshot.data!.docs[index]['owner'];
                  // Map<String, dynamic> userMap = jsonDecode(owner);
                  final UserModel user = UserModel.fromMap(owner);
                  final businessId = snapshot.data!.docs[index]['businessId'];
                  final initialPrice =
                      snapshot.data!.docs[index]['initialPrice'];
                  final imageUrl = snapshot.data!.docs[index]['images'];
                  return InkWell(
                    onTap: () {
                      Get.to(() => ServiceDetailScreen(
                            serviceId: businessId,
                          ));
                    },
                    child: MyCard(
                      title: businessName,
                      price: initialPrice,
                      description: user.fullname,
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
          Get.to(() => const AddOrUpdateBusiness());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
