// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/utils/upload_image.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/services/cloud_services.dart';

import '../services/auth_service.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder(
      stream:
          cloudService.usersCollection.doc(authService.userID()).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundImage: data['profileUrl'] != null
                      ? NetworkImage("${data['profileUrl']}")
                      : const AssetImage("assets/default/default_pp.png")
                          as ImageProvider,
                ),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.white),
                        ),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () {
                        UploadImage.uploadProfileImage();
                      },
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                )
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

/*

SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/defaults/logo.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 45,
              width: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  UploadImage.uploadProfileImage();
                },
                child: Icon(Icons.camera_alt),
              ),
            ),
          )
        ],
      ),
    )

*/