import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/themes.dart';


// ignore: must_be_immutable
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('$title'),
      centerTitle: true,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      actions: [
        IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              Get.isDarkMode
                  ? Get.changeTheme(MyThemeData.lightTheme)
                  : Get.changeTheme(MyThemeData.darkTheme);
            })
      ],
    );
  }
}
