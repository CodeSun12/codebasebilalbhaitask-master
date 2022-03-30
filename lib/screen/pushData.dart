import 'package:codebasebilalbhaitask/screen/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';


class PullDataClass extends StatefulWidget {
  const PullDataClass({Key? key}) : super(key: key);

  @override
  State<PullDataClass> createState() => _PullDataClassState();
}

class _PullDataClassState extends State<PullDataClass> {


  @override
  Widget build(BuildContext context) {

    CheckoutProvider checkoutProvider  = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle:  true,
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Push Data on Server"),
      ),
      body: SafeArea(
        child: Center(
          child: MaterialButton(
            onPressed: (){
              checkoutProvider.uploadData();
            },
            color: Colors.deepOrangeAccent,
            child: Text("Send Data On Server", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }

}
