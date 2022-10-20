import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/order_detail.dart';

import '../models/business_model.dart';
import '../models/user_model.dart';
import '../services/cloud_services.dart';
import '../utils/bottom_appbar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: cloudService.ordersCollection
            .where('bookedService.owner.uid', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final bookingId = snapshot.data!.docs[index]['id'];
                  final bookedBy = snapshot.data!.docs[index]['bookedBy'];
                  final bookedService =
                      snapshot.data!.docs[index]['bookedService'];
                  final UserModel user = UserModel.fromMap(bookedBy);
                  final BusinessModel service =
                      BusinessModel.fromMap(bookedService);

                  return InkWell(
                    child: ListTile(
                      title: Text('${service.businessName}'),
                      subtitle: Text(bookingId + " | " + user.fullname),
                    ),
                    onTap: () => Get.to(() => OrderDetail(orderNo: bookingId)),
                  );
                },
              );
            } else {
              return Center(
                  child: Text(
                "Sorry, Something went wrong.\n${snapshot.error}",
                style: const TextStyle(
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
