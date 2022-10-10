import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/services/auth_service.dart';
import 'package:vendor_app/utils/view_text_field.dart';
import '../utils/profile_pic_with_edit_button.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String password = "123456"; // FIXME:
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
              const ProfilePicWithEditButton(),
              const SizedBox(height: 20),
              ViewTextField(
                leading: Icons.account_circle,
                title: currentUser!.displayName!,
              ),
              ViewTextField(
                leading: Icons.email_outlined,
                title: currentUser.email!,
              ),
              ViewTextField(
                leading: Icons.check,
                title: 'Verified: ${currentUser.emailVerified}',
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
                child: ElevatedButton(
                  onPressed: () {
                    if (currentUser.emailVerified == false) {
                      AuthController.instance.sendEmailVerifyLink();
                    } else {
                      return;
                    }
                  },
                  // onPressed: null,
                  child: const Text('Verify Email'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
                child: ElevatedButton(
                  onPressed: () {
                    AuthController.instance
                        .deleteUser(currentUser.email!, password);
                  },
                  child: const Text('Delete User'),
                ),
              ),
            ],
          )),
    );
  }
}
