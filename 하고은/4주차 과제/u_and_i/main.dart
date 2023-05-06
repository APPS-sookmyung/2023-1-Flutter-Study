import 'package:u_and_i/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          // 테마를 지정할 수 있는 클래스
          // 위젯이름Theme의 규칙을 이용해서 특정 테마 작업 가능
          textTheme: TextTheme(
        // 글자 테마를 적용할 수 있는 클래스
        headline1: TextStyle(
          color: Colors.white,
          fontSize: 80.0,
          fontWeight: FontWeight.w700,
        ),
        headline2: TextStyle(
          color: Colors.white,
          fontSize: 50.0,
          fontWeight: FontWeight.w700,
        ),
        bodyText1: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
        bodyText2: TextStyle(color: Colors.white, fontSize: 20.0),
      )),
      home: HomeScreen(),
    ),
  );
}
