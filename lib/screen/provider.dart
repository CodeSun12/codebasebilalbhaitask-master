

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class CheckoutProvider with ChangeNotifier{

  Position? position;

  // Push Data
  uploadData() async{
    try{
      var latitude = position!.latitude.toString();
      var longitude = position!.longitude.toString();

      // Get TimeStamp
      DateTime _now = DateTime.now();
      var timestamp = '${_now.hour}:${_now.minute}:${_now.second}';


      var response = await post(Uri.parse('http://codebase.pk:8800/api/location/'),
          body: {
            "latitude": latitude,
            "longitude": longitude,
            "timestamp": timestamp,
          });
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        print(data);
        print("Uploaded Location Successfully");
        Fluttertoast.showToast(msg: "Uploaded Successfully");
      }else{
        print("Not Uploaded Location");
        Fluttertoast.showToast(msg: "Not Uploaded Successfully");
      }
    }catch(e){
      print(e.toString());
    }
  }

  // Pull Data
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
