// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
//
//
//
// class RetHomePage extends StatefulWidget {
//   @override
//   _RetHomePageState createState() => _RetHomePageState();
// }
//
// class _RetHomePageState extends State<RetHomePage> {
//   final textcontroller = TextEditingController();
//   final databaseRef = FirebaseDatabase.instance.reference();
//   Completer<GoogleMapController> _controller = Completer();
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//   GoogleMapController? googleMapController;
//
//   double latitude = 0;
//   double longitude = 0;
//   var myList = [];
//   List<LatLng> list = [];
//
//   void initState() {
//     super.initState();
//     setState(() {
//       firebaseRead();
//     });
//   }
//
//   void firebaseRead() async {
//     databaseRef
//         .child('Locations')
//         .onValue
//         .listen((event) async {
//       myList = event.snapshot.value;
//
//       setState(() {
//         for (int x = 0; x < myList.length; x++) {
//           double latitude = myList[x]['lat'];
//           double longitude = myList[x]['long'];
//           LatLng location = new LatLng(latitude, longitude);
//           if (list.contains(location)) {
//             list.clear();
//             list.add(location);
//           } else {
//             list.add(location);
//           }
//
//           addMarker(list[x]);
//         }
//       });
//     });
//     //print(list);
//   }
//
//   void addMarker(loc) {
//     final MarkerId markerId = MarkerId('Marker 1');
//
//     final Marker marker = Marker(
//       markerId: markerId,
//       position: LatLng(loc.latitude, loc.longitude),
//       infoWindow: InfoWindow(title: 'test'),
//     );
//
//     setState(() {
//       // adding a new marker to map
//       markers[markerId] = marker;
//       //print(marker);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Firebase Demo"),
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         markers: Set.of(markers.values),
//         initialCameraPosition:
//         CameraPosition(target: LatLng(6.9271, 79.8612), zoom: 15),
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           firebaseRead();
//         },
//         label: const Text('Refresh'),
//         icon: const Icon(Icons.refresh),
//         backgroundColor: Colors.blueAccent,
//       ),
//     );
//   }
// }