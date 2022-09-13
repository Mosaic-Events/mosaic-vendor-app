import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/firebase_options.dart';
import 'package:vendor_app/screens/aaaa.dart';
import 'package:vendor_app/services/connectivity_provider.dart';

import 'services/auth_service.dart';
import 'services/cloud_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<CloudService>(
          create: (_) => CloudService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: const CheckInternetConnection(),
        // home: const Wrapper(),
      ),
    );
  }
}
