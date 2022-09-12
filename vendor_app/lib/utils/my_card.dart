// ignore_for_file: prefer_const_constructors, must_be_immutable, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/forms/add_update_business.dart';

import '../services/cloud_services.dart';

class MyCard extends StatefulWidget {
  String title;
  String description;
  String price;
  String businessId;
  List imageUrl;

  MyCard({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.businessId,
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
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.40,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(widget.imageUrl[0]),
                      fit: BoxFit.cover),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Text(
                      widget.description,
                      style: TextStyle(),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textScaleFactor: 1.25,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddOrUpdateBusiness(
                                  businessId: widget.businessId,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteBusiness(widget.businessId);
                          },
                          icon: const Icon(Icons.delete),
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

  deleteBusiness(businessId) {
    final cloudService = Provider.of<CloudService>(context, listen: false);
    cloudService.businessCollection.doc(businessId).delete().whenComplete(() {
      Fluttertoast.showToast(msg: "Business Deleted");
    });
  }
}
