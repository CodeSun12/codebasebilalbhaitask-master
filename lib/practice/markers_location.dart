import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AsifTajPage extends StatefulWidget {
  const AsifTajPage({Key? key}) : super(key: key);

  @override
  _AsifTajPageState createState() => _AsifTajPageState();
}

class _AsifTajPageState extends State<AsifTajPage> {


  Completer<GoogleMapController> controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(30.157467, 71.440754),
      zoom: 14
  );

  // List of Marker
  List<Marker> markers = [];
  List<Marker> list = const [
    Marker(markerId: MarkerId("1"),
        position: LatLng(30.157467, 71.440754),
        infoWindow: InfoWindow(title: "My Position")
    ),
    Marker(markerId: MarkerId("2"),
        position: LatLng(30.16314616, 71.44277073),
        infoWindow: InfoWindow(title: "My Position")
    ),


  ];

  @override
  void initState() {
    super.initState();
    markers.addAll(list);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(markers),
        onMapCreated: (GoogleMapController myController){
          controller.complete(myController);
        },
      ),
    );
  }
}