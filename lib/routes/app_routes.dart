import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/screen/home_screen.dart';
import 'package:flutter_firebase_1/screen/login_screen.dart';
import 'package:flutter_firebase_1/screen/setting_screen.dart';
import 'package:flutter_firebase_1/screen/register_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/login': (contex) => LoginScreen(),
  '/home': (context) => HomeScreen(),
  '/setting': (context) => SettingScreen(),
  '/register': (context) => RegisterScreen()
};
