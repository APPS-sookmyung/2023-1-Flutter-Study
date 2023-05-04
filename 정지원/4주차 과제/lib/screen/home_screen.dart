import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime Dday = DateTime.now();


  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(
              onBookPressed: onBookPressed,
              Dday: Dday,
            ),
            _StudyImage(),
          ],
        ),
      ),
    );
  }

  void onBookPressed() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  Dday = date;
                });
              },
            ),
          ),
        );

      },
      barrierDismissible: true,
    );
  }
}

class _DDay extends StatelessWidget {

  final GestureTapCallback onBookPressed;
  final DateTime Dday;

  _DDay({
    required this.onBookPressed,
    required this.Dday,

  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final now = DateTime.now();
    final restTime = DateTime(Dday.year, Dday.month, Dday.day).difference(now);

    return Column(
      children: [
        const SizedBox(height: 16.0),
        Text(
          'D-Day',
          style: textTheme.headline1,
        ),
        const SizedBox(height: 16.0),
        Text(
          '중간고사',
          style: textTheme.bodyText1,
        ),
        Text(
          '${Dday.year}.${Dday.month}.${Dday.day}',
          style: textTheme.bodyText2,
        ),
        const SizedBox(height: 16.0),
        IconButton(
          iconSize: 60.0,
          onPressed: onBookPressed,
          icon: Icon(
            Icons.menu_book,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          '${restTime.inHours}:${restTime.inSeconds}:${restTime.inMilliseconds}',
          style: textTheme.headline2,
        ),
      ],
    );
  }
}

class _StudyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          'asset/img/study.jpg',
          height: MediaQuery
              .of(context)
              .size
              .height /2,
        ),
      ),
    );
  }
}