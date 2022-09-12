// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class BusinessSettingScreen extends StatefulWidget {
  const BusinessSettingScreen({super.key});

  @override
  State<BusinessSettingScreen> createState() => _BusinessSettingScreenState();
}

class _BusinessSettingScreenState extends State<BusinessSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Business"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Text("You have currently no data"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}

