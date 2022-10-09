import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/services/auth_service.dart';
import 'package:vendor_app/utils/view_text_field.dart';
import '../utils/profile_pic.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              const ProfilePic(),
              const SizedBox(height: 20),
              ViewTextField(
                leading: Icons.account_circle,
                title: currentUser!.displayName!,
              ),
              ViewTextField(
                leading: Icons.email_outlined,
                title: currentUser.email!,
              ),
              ElevatedButton(
                onPressed: () {
                  AuthController.instance.deleteUser();
                },
                child: const Text('Delete User'),
              ),
            ],
          )),
    );
  }
}
