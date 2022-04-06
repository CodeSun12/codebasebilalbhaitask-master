import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier{
  Location? _location;
  Location? get location => _location;


  LatLng? _locationPosition;
  LatLng? get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  //Constructor
  LocationProvider(){
    _location = new Location();
  }

  initialization() async{
    await getUserLocation();
  }

  getUserLocation() async{
    bool _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await location!.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location!.requestService();

      if(!_serviceEnabled){
        return;
      }
    }

    _permissionGranted = await location!.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location!.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    location?.onLocationChanged.listen((LocationData currentLocation) async{
      var response = await http.get(Uri.parse('http://codebase.pk:8800/api/location/'));
      var data = jsonDecode(response.body.toString());
      List<dynamic> myData = data;
      var latitude = myData[myData.length - 1]['latitude'];
      var longitude = myData[myData.length - 1]['longitude'];
      print("Latitude Of last Index is $latitude, Longitude of Last Index is $longitude");
       // print(myData);

      _locationPosition = LatLng(latitude, longitude);
      print(_locationPosition);
      notifyListeners();
    });
  }

}