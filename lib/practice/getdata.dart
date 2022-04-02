import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:codebasebilalbhaitask/model/GetMyModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


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


  // myLocation(double lat, double long) async{
  // List<GetMyModel> postList = [];
  // final response = await http.get(Uri.parse('http://codebase.pk:8800/api/location/'),);
  // var data = jsonDecode(response.body.toString());
  // if(response.statusCode == 200){
  //   print(data);
  //   print(lat);
  //   print(long);
  //   List<Marker> list = [
  //     Marker(markerId: MarkerId("10"),
  //
  //     )
  //   ];
  // }
  // }
   Completer<GoogleMapController> completer = Completer();

double? lat;
double? long;

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Rest Api Get Data"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getPostApi(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Text("Loading");
                    }else{
                      return ListView.builder(
                          itemCount: postList.length,
                          itemBuilder: (context, index){
                            lat = postList[index].latitude;
                            long = postList[index].longitude;
                            return LayoutBuilder(
                              builder: (ctx, constraints){
                                return GoogleMap(initialCameraPosition: CameraPosition(
                                  target: LatLng(lat!, long!),
                                  zoom: 14,
                                ),
                                  onMapCreated: (GoogleMapController controller){
                                    completer.complete(controller);
                                  },
                                );
                              },
                            );
                          });
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}




// Card(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text("Latitude", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
// Text(lat),
// Text("Longitude", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
// Text(long),
// Text("TimeStamp", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
// Text(postList[index].timestamp.toString()),
// ],
// ),
// ),
// );
