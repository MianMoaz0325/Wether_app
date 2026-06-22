// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:wether_app/screens/MainHome_screen.dart';
import 'package:wether_app/screens/splashscreen.dart';
import 'package:wether_app/screens/wetherapp.dart';
 void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splashscreen(),
    );
  }
}