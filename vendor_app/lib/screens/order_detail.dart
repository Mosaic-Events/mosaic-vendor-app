// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/appbar.dart';
import '../utils/bottom_appbar.dart';
import '../utils/my_loading_widget.dart';

class OrderDetail extends StatelessWidget {
  final String orderNo;
  const OrderDetail({
    Key? key,
    required this.orderNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Order Details'),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('booking_details')
            .doc(orderNo)
            .get(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          } else if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            final dates = data['bookedDates'];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['bookedService']['businessName'] ?? 'null',
                    style: const TextStyle(
                      fontSize: 20.00,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: Text(
                      'Date and Time',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: dates.length,
                      itemBuilder: (BuildContext context, index) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 0, 0),
                              child: Text(
                                // DateFormat.yMMMEd().format(
                                //     DateTime.fromMillisecondsSinceEpoch(
                                //         dates[index])),
                                "${dates[index]}",
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                    child: Text(
                      'Package Details',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Name'),
                      Text('Price'),
                      Text('People'),
                      Text('Total Amount'),
                    ],
                  ),
                  const Divider(
                    color: Color(0xFF0F0F0F),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${data['bookedService']['businessName']}'),
                      Text('${data['bookedService']['initialPrice']}'),
                      Text('${data['people']}'),
                      Text('${data['amount']}'),
                    ],
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: const [
                  //     Text(
                  //       'Total',
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //     Text(
                  //       'Rs. 300',
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ),
            );
          }
          return const MyLoadingWidget();
        },
      ),
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }

  timeToDate(List timestamps) {
    List<DateTime> dates = [];
    for (Timestamp timestamp in timestamps) {
      dates.add(timestamp.toDate());
    }
    return dates;
  }
}
