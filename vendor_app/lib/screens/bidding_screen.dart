import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/screens/bidding_detail.dart';

import '../models/business_model.dart';
import '../models/user_model.dart';
import '../utils/appbar.dart';
import '../utils/bottom_appbar.dart';

class MyBiddingScreen extends StatelessWidget {
  const MyBiddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: MyAppBar(title: 'My Biddings'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bidding_details')
            .where('bidBy.uid', isEqualTo: user)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final biddingId = snapshot.data!.docs[index]['id'];
                  final bidBy = snapshot.data!.docs[index]['bidBy'];
                  final biddingService =
                      snapshot.data!.docs[index]['biddingService'];
                  final UserModel user = UserModel.fromMap(bidBy);
                  final BusinessModel service =
                      BusinessModel.fromMap(biddingService);

                  return InkWell(
                    child: ListTile(
                      title: Text('${service.businessName}'),
                      subtitle: Text(biddingId + " | " + user.fullname),
                    ),
                    onTap: () =>
                        Get.to(() => BiddingDetail(biddingId: biddingId)),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                "Sorry, Something went wrong.",
                style: TextStyle(
                  fontSize: 15,
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
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }
}
