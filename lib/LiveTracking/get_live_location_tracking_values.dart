import 'dart:convert';
import 'package:codebasebilalbhaitask/model/GetMyModel.dart';
import 'package:codebasebilalbhaitask/screen/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';


class GetLiveLocationTracking extends StatefulWidget {
  const GetLiveLocationTracking({Key? key}) : super(key: key);

  @override
  State<GetLiveLocationTracking> createState() => _GetLiveLocationTrackingState();
}

class _GetLiveLocationTrackingState extends State<GetLiveLocationTracking> {



  String lat = "";
  String long = "";


  // Get Location From Server Method
  List <GetMyModel>  postList = [];
//Get Api Method
  getPostApi() async{

    final response = await http.get(Uri.parse('http://codebase.pk:8800/api/location/'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200){
      for(var i in data){
        postList.add(GetMyModel.fromJson(i));
      }
      return postList;
    }else{
      return postList;
    }
  }



  GoogleMapController? googleMapController;
  List<Marker> markers = [];
  List<Marker> list = const[
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(30.1916903, 71.4430995),
      infoWindow: InfoWindow(title: "My Current Location"),
    )
  ];


  static final CameraPosition _kGooglePlex = CameraPosition(target: LatLng(30.1916903, 71.4430995),
    zoom: 14,
  );




  @override
  void initState() {
    super.initState();
    markers.addAll(list);
  }


  @override
  Widget build(BuildContext context) {
    CheckoutProvider checkoutProvider = Provider.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          centerTitle: true,
          title: Text("Rest Location From Server"),
        ),
        body:
        FutureBuilder(
          future: getPostApi(),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i){
                  lat = snapshot.data[i].latitude.toString();
                  long = snapshot.data[i].longitude.toString();
                  return ListTile(
                    title: Text("Latitude  $lat ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
                    subtitle: Text("Longitude  $long ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
                    trailing: Text("TimeStamp  ${snapshot.data[i].timestamp} ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),

                  );
                },
              );
            }
          },
        ),
    );
  }

}






