import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/services/auth_service.dart';
import 'package:vendor_app/utils/view_text_field.dart';
import '../utils/appbar.dart';
import '../utils/profile_pic_with_edit_button.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String password = "123456"; // FIXME:
    var user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: MyAppBar(title: "My Account"),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 3));
          if (user != null) {
            await user!.reload();
            user = FirebaseAuth.instance.currentUser;
          }
        },
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const ProfilePicWithEditButton(),
                const SizedBox(height: 20),
                ViewTextField(
                  leading: Icons.account_circle,
                  title: user!.displayName!,
                ),
                ViewTextField(
                  leading: Icons.email_outlined,
                  title: user.email!,
                ),
                ViewTextField(
                  leading: Icons.check,
                  title: 'Verified: ${user.emailVerified}',
                ),
                if (!user.emailVerified)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 2.5),
                    child: ElevatedButton(
                      onPressed: () {
                        if (user!.emailVerified == false) {
                          AuthController.instance.sendEmailVerifyLink();
                        } else {
                          return;
                        }
                      },
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
                          .deleteUser(user!.email!, password);
                    },
                    child: const Text('Delete User'),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
