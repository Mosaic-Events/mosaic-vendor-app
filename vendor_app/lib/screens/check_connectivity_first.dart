// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/home_screen.dart';
import 'package:vendor_app/services/connectivity_provider.dart';
import 'package:vendor_app/utils/no_internet.dart';

class CheckInternetConnection extends StatefulWidget {
  const CheckInternetConnection({super.key});

  @override
  State<CheckInternetConnection> createState() => _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, value, child) {
      return Scaffold(
        body: value.isOnline
            ? HomeScreen()
            : NoInternet(),
      );
    });
  }
}
