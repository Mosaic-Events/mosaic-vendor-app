import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/service_detail_screen.dart';

// ignore: must_be_immutable
class MyCard extends StatefulWidget {
  String id;
  String title;
  String description;
  String price;
  List imageUrl;
  final VoidCallback? onPress;

  MyCard({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.onPress,
  }) : super(key: key);

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(widget.imageUrl.first),
                    fit: BoxFit.cover),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      widget.description,
                      style: const TextStyle(),
                      textScaleFactor: 0.9,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      buttonPadding: EdgeInsets.zero,
                      children: [
                        Text(
                          "Rs. ${widget.price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textScaleFactor: 1.25,
                        ),
                        TextButton(
                          child: const Text('Details'),
                          onPressed: () {
                            Get.to(() => ServiceDetailScreen(
                                  serviceId: widget.id,
                                ));
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
