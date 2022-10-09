import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/firebase_options.dart';
import 'package:vendor_app/services/connectivity_provider.dart';

import 'services/auth_service.dart';
import 'services/cloud_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CloudService>(
          create: (_) => CloudService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        )
      ],
      // ignore: sort_child_properties_last
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              textStyle: const TextStyle(
                // fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 50), () {});
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/defaults/logo.png"),
          )),
        ),
      ),
    );
  }
}
