import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationTracking extends StatefulWidget {
  const LocationTracking({Key? key}) : super(key: key);

  @override
  State<LocationTracking> createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {

  //Create a variable that will contain the location coordinates
  var locationMessage = "";


  // Create a function that will get the current location of user
  void getCurrentLocation() async{
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    var position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator
        .getLastKnownPosition();
    print(lastPosition);

    setState((){
      locationMessage = "$position";
    });

    // Ask permission from device
    Future<void> requestPermission() async {
      await Permission.location.request();
    }
  }

  // Post Data on Server
  void pushData(var latitude, var longitude, String timestamp) async{
    try{
      var response = await post(Uri.parse('http://codebase.pk:8800/api/location/'),
        body: {
        "latitude": latitude,
          "longitude": longitude,
          "timestamp": timestamp,
        });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        print(data);
        print("Successfully Uploaded Data");
        Fluttertoast.showToast(msg: "Successfully");
      }else{
        print("Failed to Upload");
        Fluttertoast.showToast(msg: "Failed to Upload");
      }
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text(
          "Current User Tracking",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 45, color: Colors.deepOrangeAccent,),
            SizedBox(height: 30,),
            Text("Get User Current Location", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),),
            SizedBox(height: 40,),
            Container(
                margin: EdgeInsets.only(left: 50),
                child: Text("position: $locationMessage", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),)),
            SizedBox(height: 20,),
            MaterialButton(
              minWidth: 250,
              onPressed: (){
                getCurrentLocation();
              },
              color: Colors.deepOrangeAccent,
              shape: StadiumBorder(),
              child: Text("Get Location", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),

            ),
            SizedBox(height: 20,),
            MaterialButton(
              minWidth: 250,
              onPressed: (){},
              color: Colors.deepOrangeAccent,
              shape: StadiumBorder(),
              child: Text("Upload Data On Server", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),

            )
          ],
        ),
      ) ,
    );
  }
}