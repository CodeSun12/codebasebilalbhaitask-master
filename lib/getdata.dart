import 'dart:convert';
import 'package:codebasebilalbhaitask/model/GetMyModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Latitude", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
                                    Text(postList[index].latitude.toString()),
                                    Text("Longitude", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
                                    Text(postList[index].longitude.toString()),
                                    Text("TimeStamp", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
                                    Text(postList[index].timestamp.toString()),
                                  ],
                                ),
                              ),
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
