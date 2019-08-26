import 'package:checklist/ui/HomePage.dart';
import 'package:checklist/ui/ListaComprasPage.dart';


import 'package:flutter/material.dart';



void main() => runApp(MaterialApp(
  title: 'checklist',
  theme: ThemeData(

    primarySwatch: Colors.orange,
    cursorColor: Colors.orangeAccent


  ),
  debugShowCheckedModeBanner: false,
  home: HomePage(),
  routes: <String, WidgetBuilder> {
    '/listasPage': (BuildContext context) => new ListaComprasPage(),


  },
)
);