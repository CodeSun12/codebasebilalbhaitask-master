import 'dart:convert';
import 'package:codebasebilalbhaitask/model/GetMyModel.dart';
import 'package:codebasebilalbhaitask/screen/provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../practice/getdata.dart';


class GetLiveLocationTracking extends StatefulWidget {
  const GetLiveLocationTracking({Key? key}) : super(key: key);

  @override
  State<GetLiveLocationTracking> createState() => _GetLiveLocationTrackingState();
}

class _GetLiveLocationTrackingState extends State<GetLiveLocationTracking> {


  List _loadedLatAndLong = [];


  // Get Location From Server Method
  List <GetMyModel> postList = [];

  getPostApi() async {
    final response = await http.get(
        Uri.parse('http://codebase.pk:8800/api/location/'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var i in data) {
        postList.add(GetMyModel.fromJson(i));
      }
      return postList;
    } else {
      return postList;
    }
  }




  Future<void> fetchData() async{
    final response = await http.get(Uri.parse('http://codebase.pk:8800/api/location/'));
    final data = jsonDecode(response.body);
    setState(() {
      _loadedLatAndLong = data;
    });
    print(_loadedLatAndLong[10]);
  }


  static final CameraPosition intialCameraPosition = CameraPosition(target: LatLng(30.1916903, 71.4430995), zoom: 14);
  GoogleMapController? googleMapController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text("Rest Location From Server"),
      ),
      body:
      FutureBuilder(
        future: fetchData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                lat = snapshot.data[10].latitude;
                long = snapshot.data[10].longitude;
                return Container(
                  height: MediaQuery.of(context).size.height / 2.0,
                  child: GoogleMap(
                    initialCameraPosition: intialCameraPosition,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller){
                      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat!, long!))));
                      googleMapController = controller;
                    },
                  ),
                );
              },
            );
          }
        },
      ),



    );
  }
}

// ListTile(
// title: Text("Latitude  $lat ", style: TextStyle(
// color: Colors.black87, fontWeight: FontWeight.bold),),
// subtitle: Text("Longitude  $long ", style: TextStyle(
// color: Colors.black87, fontWeight: FontWeight.bold),),
// trailing: Text("TimeStamp  ${snapshot.data[i].timestamp} ",
// style: TextStyle(
// color: Colors.black87, fontWeight: FontWeight.bold),),
//
// );







