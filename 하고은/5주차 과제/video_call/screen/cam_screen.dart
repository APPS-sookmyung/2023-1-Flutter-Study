import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  _CamScreenState createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine; // 아고라 엔진을 저장할 변수
  int? uid;
  int? otherUid;

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다';
    }

    if (engine == null) {
      // 엔진이 정의되지 않았으면 새로 정의
      engine = createAgoraRtcEngine();

      // 아고라 엔진 초기화
      await engine!.initialize(
        // 초기화할 때 사용할 설정 제공
        RtcEngineContext(
          appId: APP_ID,
          // 라이브 동영상 송출에 최적화
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print('채널에 입장했습니다. uid : ${connection.localUid}');
            setState(() {
              this.uid = connection.localUid;
            });
          },
          onLeaveChannel: (RtcConnection connection, RtcStats status) {
            print('채널 퇴장');
            setState(() {
              uid = null;
            });
          },
          // elapsed: 내가 채널을 들어왔을 때부터 상대가 들어올 때까지 걸린 시간
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            // 다른 사용자 접속
            print('상대가 채널에 입장했습니다. uid : $remoteUid');
            setState(() {
              otherUid = remoteUid;
            });
          },
          // reason: 방에서 나가게 된 이유
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            // 다른 사용자가 채널을 나감
            print('상대가 채널에서 나갔습니다. uid : $uid');
            setState(() {
              otherUid = null;
            });
          },
        ),
      );

      // 송출 세팅
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo();
      await engine!.startPreview();
      // 채널 들어감
      await engine!.joinChannel(
        token: TEMP_TOKEN,
        channelId: CHANNEL_NAME,
        // 영상 세팅 -> 현재 플젝에서 불필요
        options: ChannelMediaOptions(),
        uid: 0,
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE'),
      ),
      body: FutureBuilder(
        future: init(),
        // AsyncSnapshot: future 매개변수에 입력한 함수의 결괏값 및 에러 제공
        // 제공하는 값이 변경될 때마다 builder() 함수 재실행
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.grey,
                        height: 160,
                        width: 120,
                        child: renderSubView(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (engine != null) {
                      await engine!.leaveChannel();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('채널 나가기'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget renderSubView() {
    if (uid != null) {
      // AgoraVideoView 위젯을 사용하면
      // 동영상을 화면에 보여주는 위젯을 구현할 수 있습니다.
      return AgoraVideoView(
        // VideoViewController를 매개변수로 입력해주면
        // 해당 컨트롤러가 제공해주는 동영상 정보를
        // AgoraVideoView 위젯을 통해 보여줄 수 있습니다.
        controller: VideoViewController(
          rtcEngine: engine!,

          // VideoCanvas에 0을 입력해서 내 영상을 보여줍니다.
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      // 아직 내가 채널에 접속하지 않았다면
      // 로딩 화면을 보여줍니다.
      return CircularProgressIndicator();
    }
  }

  // 내 핸드폰이 찍는 화면 렌더링
  Widget renderMainView() {
    if (otherUid != null) {
      return AgoraVideoView(
        // 상대 화면
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          // uid: 상대방 ID
          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(channelId: CHANNEL_NAME),
        ),
      );
    } else {
      // 대기 메시지
      return Center(
        child: const Text(
          '다른 사용자가 입장할 때까지 대기해주세요.',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
