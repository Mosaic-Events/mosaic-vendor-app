import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/firebase_options.dart';
import 'package:vendor_app/themes/themes.dart';
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
        // ChangeNotifierProvider(
        //   create: (context) => ConnectivityProvider(),
        // )
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: MyThemeData.lightTheme,
        darkTheme: MyThemeData.darkTheme,
        themeMode: ThemeMode.system,
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
