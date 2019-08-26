import 'dart:async';
import 'package:flutter/material.dart';
import 'package:checklist/ui/ListaComprasPage.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Container(
      color: Colors.orangeAccent,
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Image.asset("images/lg_checklist.png",
                color: Colors.white,width: 250,
          ),

            SizedBox(height: 80.0,),
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ])),
    );
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ListaComprasPage()));
  }
}

