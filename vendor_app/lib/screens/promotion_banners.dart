// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/appbar.dart';
import '../utils/upload_image.dart';

class PromotionBannerSetting extends StatefulWidget {
  const PromotionBannerSetting({Key? key}) : super(key: key);

  @override
  State<PromotionBannerSetting> createState() => _PromotionBannerSettingState();
}

class _PromotionBannerSettingState extends State<PromotionBannerSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Manage Promotion Banners",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carousel_banners')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("Loading..."),
                ],
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(data['carousel_banners_url']),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          deleteCarouselBanner(data['id']);
                        },
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            UploadImage.uploadCarouselBanner(context);
          },
          child: const Icon(Icons.add)),
    );
  }

  deleteCarouselBanner(documentId) {
    final carouselBannerToDelete = FirebaseFirestore.instance
        .collection('carousel_banners')
        .doc(documentId);
    carouselBannerToDelete.delete();
  }
}
