import 'package:flutter/material.dart';
import 'package:hello_world/screen/home_screen.dart';

void main(){
  runApp(
    MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 50.0,
            fontWeight: FontWeight.w700,
          ),
          headline2: TextStyle(
            color: Colors.black,
            fontSize: 40.0,
            fontWeight: FontWeight.w700,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
          ),
          bodyText2: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),

        )
      ),
      home: HomeScreen(),
    ),
  );
}