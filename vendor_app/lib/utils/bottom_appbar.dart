// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/screens/home_screen.dart';
import 'package:vendor_app/screens/orders_sceen.dart';
import 'package:vendor_app/screens/profile_screen.dart';

class MyBottomAppBar extends StatefulWidget {
  const MyBottomAppBar({Key? key}) : super(key: key);

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOutSine,
      duration: Duration(
        milliseconds: 800,
      ),
      child: BottomAppBar(
        color: Theme.of(context).bottomAppBarTheme.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: () {
                  Get.to(() => HomeScreen());
                },
                icon: Icon(Icons.home),
              ),
            ),
            IconButton(
              tooltip: "Notification",
              onPressed: () {
                Get.to(() => OrdersScreen());
              },
              icon: Icon(Icons.notifications_active),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Get.to(() => ProfileScreen());
                },
                icon: Icon(Icons.account_circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
