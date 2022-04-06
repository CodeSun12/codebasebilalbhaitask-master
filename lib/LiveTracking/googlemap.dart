import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'location_provider.dart';


class GetGoogleMapScreen extends StatefulWidget {
  const GetGoogleMapScreen({Key? key}) : super(key: key);

  @override
  _GetGoogleMapScreenState createState() => _GetGoogleMapScreenState();
}

class _GetGoogleMapScreenState extends State<GetGoogleMapScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Google Map Live Tracking", style: TextStyle(color: Colors.white),),
      ),
      body: googleMapUI(),
    );
  }

  Widget googleMapUI(){
    return Consumer<LocationProvider>(
      builder: (consumerContext, model, child){
        if(model.locationPosition  != null){
          return  Column(
            children: [
              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: model.locationPosition!,
                      zoom: 18
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller){},
                ),
              )
            ],
          );
        }
        return Container(child: Center(child: CircularProgressIndicator()),);
      },
    );
  }


}