
import 'package:flutter/material.dart';
import 'package:flutterpractice/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          fontFamily: 'redressed',
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.black,
              fontSize: 80.0,
              fontWeight: FontWeight.w700,
              fontFamily: 'metropolis',
            ),
            headline2: TextStyle(
              color: Colors.redAccent,
              fontSize: 50.0,
              fontWeight: FontWeight.w700,
            ),
            bodyText1: TextStyle(
              color: Colors.black26,
              fontSize: 30.0,
            ),
            bodyText2: TextStyle(
              color: Colors.black12,
              fontSize: 20.0,
            ),
          )
      ),
      home: HomeScreen(),
    ),
  );
}
