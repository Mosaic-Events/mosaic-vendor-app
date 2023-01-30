// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/models/user_model.dart';
import 'package:vendor_app/utils/bottom_appbar.dart';
import 'package:vendor_app/utils/profile_pic.dart';

import '../utils/appbar.dart';
import '../utils/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    log(currentUser!.uid.toString());

    return Scaffold(
      appBar: MyAppBar(
        title: "Home Screen",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentUser.displayName != null)
              SizedBox(
                height: 75,
                child: Row(
                  children: [
                    ProfilePic(radius: 70),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser.displayName!,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            currentUser.email!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            // Bio
            // Text(
            //   "Bio",
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Description
            // Text(
            //   "Lorem, ipsum dolor sit amet consectetur adipisicing elit. Molestias aut, repellat ipsum facere voluptate dicta obcaecati deserunt nobis suscipit eaque?",
            //   style: TextStyle(
            //     fontSize: 15,
            //   ),
            //   textAlign: TextAlign.justify,
            // ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('businesses')
                    .where('owner.uid', isEqualTo: currentUser.uid)
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
                              snapshot.data!.docs[index]['businessName'];
                          final id = snapshot.data!.docs[index]['businessId'];
                          final owner = snapshot.data!.docs[index]['owner'];
                          var user = UserModel.fromMap(owner);
                          final price =
                              snapshot.data!.docs[index]['initialPrice'];
                          final imageUrl = snapshot.data!.docs[index]['images'];
                          return MyCard(
                            id: id,
                            title: name,
                            price: price,
                            description: user.fullname!,
                            imageUrl: imageUrl,
                            onPress: () {},
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(),
    );
  }
}
