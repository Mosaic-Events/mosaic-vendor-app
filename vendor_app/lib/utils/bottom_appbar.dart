// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../themes/my_themes.dart';

class MyBottomAppBar extends StatefulWidget {
  const MyBottomAppBar({Key? key}) : super(key: key);

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  final ScrollController _scrollController = ScrollController();

  bool showBottomAppBar = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        showBottomAppBar = false;
        setState(() {});
      } else {
        showBottomAppBar = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: showBottomAppBar ? 60 : 0,
      curve: Curves.easeInOutSine,
      duration: Duration(
        milliseconds: 800,
      ),
      child: BottomAppBar(
        color: MyColors.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Icon(Icons.home),
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ChatPage()));
              },
              icon: Icon(Icons.chat),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => DiscountsPage()));
              },
              icon: Icon(Icons.discount),
            ),
            IconButton(
              tooltip: "Notification",
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => NotificationsPage()));
              },
              icon: Icon(Icons.notifications_active),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ProfileScreen()));
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