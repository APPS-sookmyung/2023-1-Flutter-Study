import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatelessWidget {
  static final LatLng companyLatLng = LatLng(
    37.638451, // 위도
    127.064724, // 경도
  );

  // 정확한 회사의 위치를 마커로 표시
  static final Marker marker =
  Marker(markerId: MarkerId('company'), position: companyLatLng);

  static final Circle circle = Circle(
      circleId: CircleId('choolCheckCircle'),
      center: companyLatLng,
      fillColor: Colors.blue.withOpacity(0.5),
      radius: 100,
      strokeColor: Colors.blue,
      strokeWidth: 1);

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 지도 위치 지정
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
                        zoom: 16, // 확대 정도
                      ),
                      myLocationEnabled: true, // 내 위치 지도에 보여주기
                      markers: Set.from([marker]),
                      circles: Set.from([circle]),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timelapse_outlined,
                          color: Colors.blue,
                          size: 50.0,
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          // 출근하기 버튼
                          onPressed: () async {
                            final curPosition =
                            await Geolocator.getCurrentPosition(); // 현재 위치

                            final distance = Geolocator.distanceBetween(
                              curPosition.latitude, // 현재 위치 위도
                              curPosition.longitude, // 현재 위치 경도
                              companyLatLng.latitude, // 회사 위치 위도
                              companyLatLng.longitude, // 회사 위치 경도
                            );

                            bool canCheck = distance < 100;

                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('출근하기'),
                                  content: Text(
                                    canCheck ? '출근을 하시겠습니까?' : '출근할수 없는 위치입니다.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('취소'),
                                    ),
                                    if (canCheck) // 출근 가능 -> 버튼 제공
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
                          child: Text('출근하기!'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            // 권한 없는 상태
            return Center(
              child: Text(
                snapshot.data.toString(),
              ),
            );
          }),
    );
  }

  AppBar renderAppBar() {
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

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();

      if (checkPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    if (checkPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    return '위치 권한이 허가 되었습니다.';
  }
}