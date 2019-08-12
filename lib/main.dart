import 'package:mylist/ui/HomePage.dart';


import 'package:flutter/material.dart';



void main() => runApp(MaterialApp(
  title: 'CheckList',
  theme: ThemeData(

    primarySwatch: Colors.orange,



  ),
  debugShowCheckedModeBanner: false,
  home: HomePage(),
)
);