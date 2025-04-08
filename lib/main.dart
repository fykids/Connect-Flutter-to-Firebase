import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/firebase_options.dart';
import 'package:flutter_firebase_1/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_1/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: SplashScreen()),
      routes: appRoutes,
    );
  }
}
