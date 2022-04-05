import 'dart:async';
import 'dart:convert';
import 'package:codebasebilalbhaitask/model/GetMyModel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class GetLiveLocationTracking extends StatefulWidget {
  const GetLiveLocationTracking({Key? key}) : super(key: key);

  @override
  State<GetLiveLocationTracking> createState() => _GetLiveLocationTrackingState();
}

class _GetLiveLocationTrackingState extends State<GetLiveLocationTracking> {


  // Get Location From Server Method
  List  <GetMyModel> postList = [];
  List<LatLng> list = [];
  double latitude = 0;
  double longitude = 0;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();



  getPostApi() async {
    final response = await http.get(
        Uri.parse('http://codebase.pk:8800/api/location/'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var i in data) {
        postList.add(GetMyModel.fromJson(i));
        setState(() {
          for(int x = 0; x < postList.length; x++){
            var latitude = postList[x].latitude;
            var longitude = postList[x].longitude;
            LatLng myLocation = LatLng(latitude!, longitude!);
            if (list.contains(myLocation)){
              list.clear();
              list.add(myLocation);
            }else{
              list.add(myLocation);
            }
            addMarker(list[x]);
          }
        });
      }
      return postList;
    } else {
      return postList;
    }
  }

  // Add Marker
  void addMarker(loc){
    final MarkerId markerId = MarkerId('Marker 1');

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(loc.latitude, loc.longitude),
      infoWindow: InfoWindow(title: "MyLocation")
    );

    setState(() {
      // Adding a New Marker On Map
      markers[markerId] = marker;
    });

  }







  static final CameraPosition intialCameraPosition = CameraPosition(target: LatLng(30.1916903, 71.4430995), zoom: 14);
  GoogleMapController? googleMapController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Demo"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set.of(markers.values),
        initialCameraPosition: intialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getPostApi();
        },
        label: const Text('Refresh'),
        icon: const Icon(Icons.refresh),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}




// Container(
// height: MediaQuery.of(context).size.height / 2.0,
// child: GoogleMap(
// initialCameraPosition: intialCameraPosition,
// mapType: MapType.normal,
// myLocationButtonEnabled: false,
// myLocationEnabled: true,
// zoomControlsEnabled: true,
// zoomGesturesEnabled: true,
// onMapCreated: (GoogleMapController controller){
// controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat!, long!))));
// googleMapController = controller;
// },
// ),
// );




// Scaffold(
// appBar: AppBar(
// backgroundColor: Colors.deepOrangeAccent,
// centerTitle: true,
// title: Text("Rest Location From Server"),
// ),
// body:
// FutureBuilder(
// future: getPostApi(),
// builder: (context, AsyncSnapshot snapshot) {
// if (snapshot.data == null) {
// return Container(
// child: Center(
// child: CircularProgressIndicator(),
// ),
// );
// } else {
// return ListView.builder(
// // physics: NeverScrollableScrollPhysics(),
// // shrinkWrap: true,
// itemCount: snapshot.data!.length,
// itemBuilder: (context, i) {
// lat = snapshot.data[i].latitude;
// long = snapshot.data[i].longitude;
// return ListTile(
// title: Text("Latitude  $lat ", style: TextStyle(
// color: Colors.black87, fontWeight: FontWeight.bold),),
// subtitle: Text("Longitude  $long ", style: TextStyle(
// color: Colors.black87, fontWeight: FontWeight.bold),),
// trailing: Text("TimeStamp  ${snapshot.data[i].timestamp} ",
// style: TextStyle(
// color: Colors.black87, fontWeight: FontWeight.bold),),
//
// );
// },
// );
// }
// },
// ),
//
//
//
// );







