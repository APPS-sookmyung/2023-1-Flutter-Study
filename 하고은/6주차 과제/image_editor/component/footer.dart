import 'package:flutter/material.dart';

typedef OnEmoticonTap = void Function(int id);

class Footer extends StatelessWidget {
  final OnEmoticonTap onEmoticonTap;

  const Footer({
    required this.onEmoticonTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.9),
      height: 150,
      // 가로로 스크롤 가능
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(
                7,
                (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // 스티커 선택 시 실행
                          onEmoticonTap(index + 1);
                        },
                        child: Image.asset(
                          'asset/img/emoticon_${index + 1}.png',
                          height: 100,
                        ),
                      ),
                    ))),
      ),
    );
  }
}
