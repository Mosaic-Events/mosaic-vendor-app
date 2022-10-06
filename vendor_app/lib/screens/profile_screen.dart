// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/screens/my_account_screen.dart';
import 'package:vendor_app/screens/settings.dart';

import '../services/auth_service.dart';
import '../utils/profile_menu.dart';
import '../utils/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(),
            SizedBox(height: 20),
            ProfileMenu(
              leading: Icons.account_circle_rounded,
              title: "My Account",
              trailing: Icons.arrow_forward,
              press: () => {Get.to(() => MyAccountScreen())},
            ),
            ProfileMenu(
              leading: Icons.settings_rounded,
              title: "Setting",
              trailing: Icons.arrow_forward,
              press: () => {Get.to(() => SettingScreen())},
            ),
            ProfileMenu(
              leading: Icons.help_center_rounded,
              title: "Help Center",
              trailing: Icons.arrow_forward,
              press: () => {},
            ),
            ProfileMenu(
              leading: Icons.logout_rounded,
              title: "Logout",
              press: () => {
                AuthController.instance.logOut(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
