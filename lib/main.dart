import 'package:codebasebilalbhaitask/practice/getdata.dart';
import 'package:codebasebilalbhaitask/screen/my_current_location.dart';
import 'package:codebasebilalbhaitask/screen/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'LiveTracking/get_live_location_tracking_values.dart';
import 'LiveTracking/live_location_tracking.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CheckoutProvider>(create: (context) => CheckoutProvider()),
      ],
      child: const MaterialApp(
        title: "Current Location",
        debugShowCheckedModeBanner: false,
        home: LiveTracking(),
      ),
    );
  }
}

