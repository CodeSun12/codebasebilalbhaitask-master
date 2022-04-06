import 'package:codebasebilalbhaitask/LiveTracking/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'LiveTracking/get_live_location_tracking_values.dart';
import 'LiveTracking/googlemap.dart';
import 'LiveTracking/just_for_check.dart';


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
        ChangeNotifierProvider<LocationProvider>(create: (context) => LocationProvider()),
      ],
      child: MaterialApp(
        title: "Current Location",
        debugShowCheckedModeBanner: false,
        home: GetGoogleMapScreen(),
      ),
    );
  }
}

