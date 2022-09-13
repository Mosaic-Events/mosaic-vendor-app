import 'package:flutter/material.dart';

class ViewTextField extends StatelessWidget {
  final IconData leading;
  final String title;

  const ViewTextField({super.key, required this.leading, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F6F9),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(leading),
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(title)),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
