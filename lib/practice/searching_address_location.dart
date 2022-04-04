import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SearchAddress extends StatefulWidget {
  const SearchAddress({Key? key}) : super(key: key);

  @override
  State<SearchAddress> createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {


  static final CameraPosition initialCameraPosition = CameraPosition(target: LatLng(30.191696, 71.4431357), zoom: 14);
  GoogleMapController? googleMapController;
  String searchAddress = "";

  // searchAndNavigate()  async{
  //   try {
  //     List<Placemark> p = await placemarkFromCoordinates(searchAddress).then((value) => null)
  //     Placemark place = p[0];
  //
  //     setState(() {
  //     });
  //   } catch (e) {
  //     print(e);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Search Address"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: (controller){
              googleMapController = controller;
            },
          ),
          Positioned(
            top: 30,
            left: 15,
            right: 15,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: TextField(
                onChanged: (val){
                  setState(() {
                    searchAddress = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Location",
                  hintStyle: TextStyle(color: Colors.black87),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  suffixIcon: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.search, size: 30.0,),
                  )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
