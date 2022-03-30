import 'dart:convert';

import 'package:codebasebilalbhaitask/screen/provider.dart';
import 'package:codebasebilalbhaitask/screen/pushData.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'get_location_from_server.dart';

class MyCurrentLocation extends StatefulWidget {
  const MyCurrentLocation({Key? key}) : super(key: key);

  @override
  State<MyCurrentLocation> createState() => _MyCurrentLocationState();
}

class _MyCurrentLocationState extends State<MyCurrentLocation> {


  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );

  // Markers Which we will show on google map
  Set<Marker> markers = {};


  // void uploadData(Position position, String timestamp) async{
  //   try{
  //     var response = await post(Uri.parse('http://codebase.pk:8800/api/location/'),
  //         body: {
  //           "latitude": position.latitude,
  //           "longitude": position.longitude,
  //           "timestamp": timestamp,
  //         });
  //     if(response.statusCode == 200){
  //       var data = jsonDecode(response.body.toString());
  //       print(data);
  //       print("Uploaded Location Successfully");
  //       Fluttertoast.showToast(msg: "Uploaded Successfully");
  //     }else{
  //       print("Not Uploaded Location");
  //       Fluttertoast.showToast(msg: "Not Uploaded Successfully");
  //     }
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    CheckoutProvider checkoutProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("My Current Location"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PullDataClass()));
          }, icon: Icon(Icons.search, size: 25,)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetLocationFromServer()));
          }, icon: Icon(Icons.add, size: 25,)),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller){
          googleMapController = controller;
        },
      ),


      // Floating Action Button
      floatingActionButton:  FloatingActionButton.extended(
        backgroundColor: Colors.deepOrangeAccent,
        splashColor: Colors.white,
        onPressed: () async{

          checkoutProvider.position = await determinePosition();
          googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(
                          checkoutProvider.position!.latitude,
                           checkoutProvider.position!.longitude,
                      ),
                    zoom: 14,
                  ),
              )
          );
          markers.clear();
          markers.add(Marker(markerId: const MarkerId("Current Location"),
              position: LatLng(checkoutProvider.position!.latitude, checkoutProvider.position!.longitude)));
          setState(() {
          });

        },
        label: const Text("Current Location", style: TextStyle(fontWeight: FontWeight.bold),),
        icon: const Icon(Icons.location_on),

      ),
    );
  }

  ///////////////////////////////////
  Future determinePosition() async{

    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error("Location Services are Disabled");
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    if(permission == LocationPermission.denied){
      return Future.error("Location Permission Denied From User");
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error("Location Permission are Denied Permanently From User");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
