import 'package:hello_world/model/video_model.dart';
import 'package:hello_world/const/api.dart';
import 'package:dio/dio.dart';

class YoutubeRepository {
  static Future<List<VideoModel>> getVideos() async {
    final resp = await Dio().get(
      YOUTUBE_API_BASE_URL,
      queryParameters: {
        'channelId': CF_CHANNEL_ID,
        'maxResult': 50,
        'key':API_KEY,
        'part':'snippet',
        'order': 'data',
      },
    );
    final listWithData =  resp.data['item'].where(
        (item) =>
            item?['id']?['videoId'] != null && item?['snippet']?['title'] != null,
    );
    return listWithData
        .map<VideoModel>(
        (item) => VideoModel(
            id: item['id']['videoId'],
            title: item['snippet']['title'],
        ),
    )
        .toList();
  }
}