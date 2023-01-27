import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:vendor_app/models/user_model.dart';
import 'package:vendor_app/services/cloud_services.dart';

import '../utils/my_loading_widget.dart';
import '../utils/upload_image.dart';
import 'image_view.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({Key? key, required this.serviceId})
      : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cloudService = Provider.of<CloudService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Detail Screen'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: cloudService.businessCollection.doc(widget.serviceId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              final name = data['businessName'];
              final owner = data['owner'];
              final images = data['images'];
              final capacity = data['capacity'];
              final UserModel user = UserModel.fromMap(owner);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.fullname ?? "null",
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "Capacity: $capacity",
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  // Images
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      UploadImage.uploadBusinessImages(data['businessId']);
                    },
                    child: const Text(
                      "Upload Images",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  // Image GridView
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 2.0,
                        ),
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            onTap: () => Get.to(() => GalleryWidget(
                                  urls: images,
                                  index: index,
                                )),
                            child: Container(
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(0.0),
                                image: DecorationImage(
                                    image: NetworkImage(images[index]),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }

            return const MyLoadingWidget();
          },
        ),
      ),
    );
  }
}
