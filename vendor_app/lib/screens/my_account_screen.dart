import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/utils/view_text_field.dart';

import '../services/auth_service.dart';
import '../utils/profile_pic.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
                title: authService.currentUser!.displayName!,
              ),
              ViewTextField(
                leading: Icons.email_outlined,
                title: authService.currentUser!.email!,
              )
            ],
          )),
    );
  }
}
