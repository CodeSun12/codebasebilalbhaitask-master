import 'package:flutter/material.dart';
import 'LiveTracking/get_live_location_tracking_values.dart';
import 'LiveTracking/just_for_check.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Current Location",
      debugShowCheckedModeBanner: false,
      home: JustForCheck(),
    );
  }
}

