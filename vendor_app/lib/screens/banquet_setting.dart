import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/forms/add_update_banquet.dart';

class BanquetSetting extends StatefulWidget {
  const BanquetSetting({Key? key}) : super(key: key);

  @override
  State<BanquetSetting> createState() => _BanquetSettingState();
}

class _BanquetSettingState extends State<BanquetSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Banquets'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('businesses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, index) {
                  final id = snapshot.data!.docs[index]['id'];
                  final name = snapshot.data!.docs[index]['name'];
                  final price = snapshot.data!.docs[index]['price'];
                  final capacity = snapshot.data!.docs[index]['capacity'];
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(capacity + ' | Rs.' + price + '/-'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteBanquet(id);
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                "Sorry, There is no data right now.\nPlease add some data first.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddOrUpdateBanquet());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  deleteBanquet(documentId) {
    final banquetToDelete =
        FirebaseFirestore.instance.collection('businesses').doc(documentId);
    banquetToDelete.delete();
  }
}
