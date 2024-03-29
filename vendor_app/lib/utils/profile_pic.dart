// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/services/cloud_services.dart';

class ProfilePic extends StatelessWidget {
  final double radius;
  const ProfilePic({Key? key, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: cloudService.usersCollection.doc(userId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return SizedBox(
            height: radius,
            width: radius,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundImage: data['profileUrl'] != null
                      ? NetworkImage("${data['profileUrl']}")
                      : const AssetImage("assets/defaults/logo.png")
                          as ImageProvider,
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
