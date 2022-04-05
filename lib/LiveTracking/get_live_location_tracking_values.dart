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


  List _data = [];


  getPostApi() async {
    final response = await http.get(
        Uri.parse('http://codebase.pk:8800/api/location/'));
    var data = jsonDecode(response.body.toString());
    print(data);
    setState(() {
      if(data != null){
        _data = data;
      }
    });
    if (response.statusCode == 200) {
      for (var i in data) {
        postList.add(GetMyModel.fromJson(i));
        setState(() {
          for(int x = 0; x < _data.length; x++){
            var latitude = _data[x]['latitude'];
            var longitude = _data[x]['longitude'];
            String timestamp  = _data[x]['timestamp'];
            LatLng myLocation = LatLng(latitude!, longitude!);
            if (list.contains(myLocation)){
              list.clear();
              list.add(myLocation);
            }else{
              list.add(myLocation);
            }
            addMarker(list[x], x);
          }
        });
      }
    }
  }

//Adding Index here as an argument
  void addMarker(loc, index) {
    //Making this markerId dynamic
    final MarkerId markerId = MarkerId('Marker  $index');

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(loc.latitude, loc.longitude),
      infoWindow: InfoWindow(title: 'MyLocation'),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
      //print(marker);
    });
  }







  static final CameraPosition initialCameraPosition = CameraPosition(target: LatLng(30.1916903, 71.4430995), zoom: 14);
  GoogleMapController? googleMapController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Get Location From Server"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set.of(markers.values),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getPostApi();
        },
        label: const Text('Refresh'),
        icon: const Icon(Icons.refresh),
        backgroundColor: Colors.deepOrangeAccent,
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}







