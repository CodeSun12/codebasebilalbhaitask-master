import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';



class GetLoc extends StatefulWidget {
  const GetLoc({Key? key}) : super(key: key);

  @override
  State<GetLoc> createState() => _GetLocState();
}

class _GetLocState extends State<GetLoc> {
  
  
  static final CameraPosition initialLocation = CameraPosition(target:  LatLng(37.42796133580664 , -122.085749655962), zoom: 14.4746);
   GoogleMapController? googleMapController;
   Completer<GoogleMapController> newGoogleMapController = Completer();
   Position? currentPosition;
   var geoLocator = Geolocator();

   void locatePosition() async{


     // Permission Taking Line From
     bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
     await Geolocator.checkPermission();
     await Geolocator.requestPermission();


     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     currentPosition = position;

     LatLng latLngPosition = LatLng(position.latitude, position.longitude);

     CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
     googleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


     // Ask permission from device
     Future<void> requestPermission() async {
       await Permission.location.request();
     }


   }
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Get Loc"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialLocation,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller){
              newGoogleMapController.complete(controller);
              googleMapController = controller;

            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'recenterr',
        onPressed: () {
          locatePosition();
        },
        child: Icon(
          Icons.my_location,
          color: Colors.grey,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Color(0xFFECEDF1))),
      ),
    );
  }
}
