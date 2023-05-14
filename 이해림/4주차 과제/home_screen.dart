import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({key? key}) : super(key: key);

  class _DDay extends StatelessWidget {
    final GestureTapCallback onHeartPressed;
    final DateTime firstDay;

  _DDay({
    required this.onHeartPressed,
  required this.firstDay,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now();

@override
Widget build(BuildContext context) {
  // This method is rerun every time setState is called, for instance as done
  // by the _incrementCounter method above.
  //
  // The Flutter framework has been optimized to make rerunning build methods
  // fast, so that you can just rebuild anything that needs updating rather
  // than having to individually change instances of widgets.
  return Scaffold(
  backgroundColor: Colors.white,
  body: SafeArea(
  top: true,
  bottom: false,
  child: Column(

  mainAxisAlignment: MainAxisAlignment.spaceBetween,

  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
  _DDay(
  onHeartPressed: onHeartPressed,
  firstDay: firstDay,
  ),
  _CoupleImage(),
  ],
  ),
  ),
  );
  }
  @override
  Widget build(BuildContext context) {
          final textTheme = Theme.of(context).textTheme;
          final now = DateTime.now();
          final restTime = DateTime(now.year, now.month, now.day).difference(firstDay);

          return Column(
            children: [
              const SizedBox(height: 16.0),
              Text(
                'Walking',
              ),
              const SizedBox(height: 16.0),
              Text(
                '걷기 시작한 날',
              ),
              const SizedBox(height: 16.0),
              Text(
              '${firstDay.year}.${firstDay.month}.${firstDay.day}',
              ),
              const SizedBox(height: 16.0),
              IconButton(
                iconSize: 60.0,
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: Colors.pink,
  ),
  ),
              const SizedBox(height: 16.0),
              Text(
                '${restTime.inHours}:${restTime.inSeconds}:${restTime.inMilliseconds}',
                ),
  ],
  );
}
}
class_CopleImage extends StatelessWidget {
  @override
  widget build(BuildContext context) {
  return Center(
  child: Image.asset(
  'asset/img/middle_image.png',

  height: MediaQuery.of(context).size,height / 2,
  ),
  );
  }
  }
  void onHeartPressed() {
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
                firstDay = date;
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
