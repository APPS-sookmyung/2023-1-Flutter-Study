import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 상태관리할 값은 '처음 만난 날'
  DateTime firstDay = DateTime.now(); // 오늘

  // 하트버튼 click->날짜 선택 가능, firstDay변수 변경
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
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
            _RunImage(),
          ],
        ),
      ),
    );
  }

  void onHeartPressed() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          // 정렬을 지정하는 위젯
          alignment: Alignment.bottomCenter, // 아래 중간으로 정렬
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

    // setState 테스트를 위한 코드
    // setState(() {
    //   firstDay = firstDay.subtract(Duration(days: 1));
    // });
  }
}

class _DDay extends StatelessWidget {
  // 하트 눌렀을때 실행할 함수
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay; // 시작한 날

  _DDay({
    required this.onHeartPressed,
    required this.firstDay,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now(); // 현재 날짜 시간

    var remainDateTime =
        DateTime(now.year, now.month, now.day).difference(firstDay);
    var remainDays = remainDateTime.inDays;

    return Column(
      children: [
        const SizedBox(height: 16.0),
        Text(
          'Running Day',
          style: textTheme.headline1,
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          (remainDays >= 0) ? '처음 달리기를 시작한 날' : '처음 달리기를 시작할 날',
          style: textTheme.bodyText1,
        ),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          '${firstDay.year}.${firstDay.month}.${firstDay.day}',
          style: textTheme.bodyText2,
        ),
        const SizedBox(
          height: 12.0,
        ),
        IconButton(
          iconSize: 60.0,
          onPressed: onHeartPressed,
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
        Text(
          (remainDays >= 0)
              ? '+${remainDateTime.inHours}시 ${remainDateTime.inMinutes}분 ${remainDateTime.inSeconds}초'
              : '${remainDateTime.inHours}시 ${-remainDateTime.inMinutes}분 ${-remainDateTime.inSeconds}초',
          style: textTheme.headline2,
        ),
      ],
    );
  }
}

class _RunImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          'asset/img/middle_image.png',
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }
}
