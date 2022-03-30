import 'dart:convert';

import 'package:codebasebilalbhaitask/model/GetMyModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class GetLocationFromServer extends StatefulWidget {
  const GetLocationFromServer({Key? key}) : super(key: key);

  @override
  State<GetLocationFromServer> createState() => _GetLocationFromServerState();
}

class _GetLocationFromServerState extends State<GetLocationFromServer> {

  // Get Location From Server Method
  Future getUserLocation()async{
    var response = await http.get(Uri.parse('http://codebase.pk:8800/api/location/'));
    var data = jsonDecode(response.body.toString());
    List<GetData> lctn = [];

    for(var i in data){
      GetData getData = GetData(latitude: i['latitude'].toString(), longitude: i['longitude'].toString(), timestamp: i['timestamp'].toString());
      lctn.add(getData);
    }
    print(lctn.length);
    return lctn;
  }

  GoogleMapController? googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text("Rest Location From Server"),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getUserLocation(),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }else return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i){
                  return ListTile(
                    title: Text(snapshot.data[i].latitude),
                    subtitle: Text(snapshot.data[i].longitude),
                    trailing: Text(snapshot.data[i].timestamp),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}


  // Making a Class To Get Data
 class GetData{
  String? latitude;
  String? longitude;
  String? timestamp;

  GetData({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
 });
 }




//
// GoogleMap(
// initialCameraPosition: CameraPosition(
// target: LatLng(snapshot.data[i].latitude, snapshot.data[i].longitude),
// ),
// mapType: MapType.normal,
// zoomControlsEnabled: false,
// onMapCreated: (GoogleMapController controller){
// googleMapController = controller;
// },
// )