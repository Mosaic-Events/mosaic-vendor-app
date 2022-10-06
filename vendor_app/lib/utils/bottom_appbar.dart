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
                onPressed: () {},
                icon: Icon(Icons.home),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.chat),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.discount),
            ),
            IconButton(
              tooltip: "Notification",
              onPressed: () {},
              icon: Icon(Icons.notifications_active),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.account_circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
