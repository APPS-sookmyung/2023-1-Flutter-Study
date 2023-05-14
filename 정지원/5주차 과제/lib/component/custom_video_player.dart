import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:vid_player/component/custom_icon_button.dart';

enum PlaybackSpeed {
  normal,
  speed1_25x,
  speed1_5x,
  speed1_75x,
  speed2x,
}

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool showControls = false;
  VideoPlayerController? videoController;
  PlaybackSpeed playbackSpeed = PlaybackSpeed.normal;

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    videoController.addListener(videoControllerListener);

    setState(() {
      this.videoController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    videoController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              videoController!,
            ),
            if (showControls)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    renderTimeTextFromDuration(
                      videoController!.value.position,
                    ),
                    Expanded(
                      child: Slider(
                        onChanged: (double val) {
                          videoController!.seekTo(
                            Duration(seconds: val.toInt()),
                          );
                        },
                        value: videoController!.value.position.inSeconds
                            .toDouble(),
                        min: 0,
                        max: videoController!.value.duration.inSeconds
                            .toDouble(),
                      ),
                    ),
                    renderTimeTextFromDuration(
                      videoController!.value.duration,
                    ),
                    SizedBox(width: 8),
                    DropdownButton<PlaybackSpeed>(
                      value: playbackSpeed,
                      onChanged: onSpeedChanged,
                      items: [
                        DropdownMenuItem(
                          value: PlaybackSpeed.normal,
                          child: Text('x1.0'),
                        ),
                        DropdownMenuItem(
                          value: PlaybackSpeed.speed1_25x,
                          child: Text('x1.25'),
                        ),
                        DropdownMenuItem(
                          value: PlaybackSpeed.speed1_5x,
                          child: Text('x1.5'),
                        ),
                        DropdownMenuItem(
                          value: PlaybackSpeed.speed1_75x,
                          child: Text('x1.75'),
                        ),
                        DropdownMenuItem(
                          value: PlaybackSpeed.speed2x,
                          child: Text('x2.0'),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    CustomIconButton(
                      iconData: Icons.refresh,
                      onPressed: widget.onNewVideoPressed,
                      icon: Icons.refresh,
                    ),
                  ],
                ),
              ),
            ),
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed: widget.onNewVideoPressed,
                  iconData: Icons.photo_camera_back,
                  icon: Icons.photo_camera_back,
                ),
              ),
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                      icon: Icons.rotate_left,
                    ),
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      icon: videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    CustomIconButton(
                      onPressed: onFowardPressed,
                      iconData: Icons.rotate_right,
                      icon: Icons.rotate_right,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onSpeedChanged(PlaybackSpeed? value) {
    setState(() {
      playbackSpeed = value!;
      switch (playbackSpeed) {
        case PlaybackSpeed.normal:
          videoController!.setPlaybackSpeed(1.0);
          break;
        case PlaybackSpeed.speed1_25x:
          videoController!.setPlaybackSpeed(1.25);
          break;
        case PlaybackSpeed.speed1_5x:
          videoController!.setPlaybackSpeed(1.5);
          break;
        case PlaybackSpeed.speed1_75x:
          videoController!.setPlaybackSpeed(1.75);
          break;
        case PlaybackSpeed.speed2x:
          videoController!.setPlaybackSpeed(2.0);
          break;
      }
    });
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:'
      '${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;

    Duration position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onFowardPressed() {
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;

    Duration position = maxPosition;

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
