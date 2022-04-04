import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



 class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future? _future;

  Future<String> loadString() async =>
      await rootBundle.loadString('http://codebase.pk:8800/api/location/');
  List<Marker> allMarkers = [];
  GoogleMapController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = loadString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
              children: [
            FutureBuilder(
              future: _future,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                List<dynamic> parsedJson = jsonDecode(snapshot.data);
                allMarkers = parsedJson.map((element) {
                  return Marker(
                      markerId: MarkerId(element['timestamp']),
                      position: LatLng(element['latitude'], element['longitude']));
                }).toList();
            return GoogleMap(
              initialCameraPosition:
              CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 1.0),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            );
              }),
          ]),
        ),
      ]),
    );
  }
  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}