import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:relxsg/app_constant.dart';
import 'package:relxsg/home.dart';

void main() {
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (dynamic error, dynamic stack) {
    log("Something went wrong!", error: error, stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstant.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SafeArea(child: Home()),
    );
  }
}
