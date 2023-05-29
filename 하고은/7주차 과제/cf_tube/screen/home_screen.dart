import 'package:flutter/material.dart';
import 'package:cf_tube/model/video_model.dart';
import 'package:cf_tube/component/custom_youtube_player.dart';
import 'package:cf_tube/repository/youtube_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '코팩튜브',
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<VideoModel>>(
        future: YoutubeRepository.getVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // 에러 처리
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData) {
            // 로딩 중
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator( // 새로 고침 기능
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              // 튕기는 애니메이션 추가
              physics: BouncingScrollPhysics(),
              children: snapshot.data!
                  .map((e) => CustomYoutubePlayer(videoModel: e))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
