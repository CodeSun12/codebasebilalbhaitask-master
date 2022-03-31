import 'dart:convert';
import 'package:codebasebilalbhaitask/model/GetMyModel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class GetLocationFromServer extends StatefulWidget {
  const GetLocationFromServer({Key? key}) : super(key: key);

  @override
  State<GetLocationFromServer> createState() => _GetLocationFromServerState();
}

class _GetLocationFromServerState extends State<GetLocationFromServer> {

  // Get Location From Server Method
  List <GetMyModel>  postList = [];
//Get Api Method
  Future<List<GetMyModel>> getPostApi() async{
    final response = await http.get(Uri.parse('http://codebase.pk:8800/api/location/'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200){
      for(Map i in data){
        postList.add(GetMyModel.fromJson(i));
      }
      return postList;
    }else{
      return postList;
    }
  }


  GoogleMapController? googleMapController;
  Set<Marker> markers = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text("Rest Location From Server"),
      ),
      body: FutureBuilder(
        future: getPostApi(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }return GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(33.6844, 73.0479)
              ),
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller){
                googleMapController = controller;
                googleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(postList[0].latitude ?? 0, postList[0].longitude ?? 0))));
                markers.clear();
                markers.add(Marker(markerId: const MarkerId("Current Location"),
                    position: LatLng(postList[0].latitude ?? 0, postList[0].longitude ?? 0)));
                setState(() {});

                },

          );
        },

      )
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






// FutureBuilder(
// future: getUserLocation(),
// builder: (context, AsyncSnapshot snapshot){
// if(snapshot.data == null){
// return Container(
// child: Center(
// child: CircularProgressIndicator(),
// ),
// );
// }else {
// return ListView.builder(
// itemCount: snapshot.data!.length,
// itemBuilder: (context, i){
// return ListTile(
// title: Text("Latitude  ${snapshot.data[i].latitude} ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
// subtitle: Text("Longitude  ${snapshot.data[i].longitude} ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
// trailing: Text("TimeStamp  ${snapshot.data[i].timestamp} ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
//
// );
// },
// );
// }
// },
// ),