// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/forms/add_update_business.dart';

import '../services/cloud_services.dart';

class MyCard extends StatefulWidget {
  String title;
  String? description;
  String price;
  String businessId;
  List imageUrl;

  MyCard({
    Key? key,
    required this.title,
    this.description,
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
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: widget.imageUrl.isNotEmpty
                        ? NetworkImage(widget.imageUrl[0])
                        : const AssetImage('assets/images/placeholder01.jpg')
                            as ImageProvider,
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
                      widget.description!,
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
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Get.to(() => AddOrUpdateBusiness(
                                  businessId: widget.businessId,
                                ));
                          },
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
