import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatelessWidget {
  static final LatLng companyLatLng = LatLng(
    37.5233273, // 위도
    126.921252, // 경도
  );

  static final Marker marker = Marker(
    markerId: MarkerId('company'), //회사 위치 마커 선언
    position: companyLatLng,
  );

  static final Circle circle = Circle(
    circleId: CircleId('choolCheckCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
          future: checkPermission(),
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == '위치 권한이 허가 되었습니다.') {
              return Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: companyLatLng,
                        zoom: 16,
                      ),
                      myLocationEnabled: true,
                      markers: Set.from([marker]), //Set로 Marker 제공
                      circles: Set.from([circle]),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          //시계 아이콘
                          Icons.timelapse_outlined,
                          color: Colors.blue,
                          size: 50.0,
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            final curPosition =
                                await Geolocator.getCurrentPosition();
                            final distance = Geolocator.distanceBetween(
                              curPosition.latitude,
                              curPosition.longitude,
                              companyLatLng.latitude,
                              companyLatLng.longitude,
                            );
                            bool canCheck = distance < 100;
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("출근하기"),
                                  content: Text(
                                    canCheck ? '출근하시겠습니까?' : '출근할 수 없는 위치입니다.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('취소'),
                                    ),
                                    if (canCheck)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text('출근하기'),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("출근하기!"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(
              //권한 없는 상태
              child: Text(
                snapshot.data.toString(),
              ),
            );
          }),
    );
  }

  AppBar renderAppBar() {
    //AppBar 구현 함수
    return AppBar(
      centerTitle: true,
      title: Text(
        '오늘도 출첵',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    //  위치 서비스 활성화 여부 확인
    if (!isLocationEnabled) {
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();
    //위치 권한 확인
    if (checkedPermission == LocationPermission.denied) {
      //위치 권한 거절됨
      checkedPermission = await Geolocator.requestPermission();
      //위치 권한 요청하기
      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요';
      //  위치 권한 거절됨(앱에서 재요청 불가)
    }
    return '위치 권한이 허가되었습니다.';
    //  위 모든 조건이 통과되면 위치 권한 허가 완료
  }
}
