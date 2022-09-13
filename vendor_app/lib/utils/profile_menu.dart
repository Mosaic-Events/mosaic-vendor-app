import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu(
      {Key? key,
      required this.leading,
      required this.title,
      this.trailing,
      this.press})
      : super(key: key);

  final IconData leading;
  final String title;
  final IconData? trailing;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(leading),
            const SizedBox(width: 20),
            Expanded(child: Text(title)),
            Icon(trailing),
          ],
        ),
      ),
    );
  }
}
