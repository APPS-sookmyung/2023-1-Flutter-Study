import 'package:flutter/material.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/model/sticker_model.dart';
import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;
  Set<StickerModel> stickers = {}; // 화면에 추가된 스티커
  String? selectedId;
  GlobalKey imgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        renderBody(),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: MainAppBar(
            onPickImage: onPickImage,
            onSaveImage: onSaveImage,
            onDeleteItem: onDeleteItem,
          ),
        ),
        if (image != null)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              // 가장 아래 배치
              child: Footer(
                onEmoticonTap: onEmoticonTap,
              ))
      ],
    ));
  }

  Widget renderBody() {
    if (image != null) {
      return RepaintBoundary(
        // 위젯을 이미지로 저장
        key: imgKey,
        child: Positioned.fill(
          // 위젯 확대와 좌우 이동 가능
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(image!.path),
                fit: BoxFit.cover,
              ),
              ...stickers.map(
                // 최초 스티커 선택 시 중앙 배치
                (sticker) => Center(
                  child: EmoticonSticker(
                    key: ObjectKey(sticker.id),
                    onTransform: () {
                      onTransform(sticker.id);
                    },
                    imgPath: sticker.imgPath,
                    isSelected: selectedId == sticker.id,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 이미지 선택이 안 된 경우 이미지 선택 버튼 표시
      return Center(
          child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.grey,
        ),
        onPressed: onPickImage,
        child: Text('이미지 선택하기'),
      ));
    }
  }

  // 스티커 누를 때마다 업데이트
  void onEmoticonTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(), // 절대로 겹치지 않는 String 값 생성
          imgPath: 'asset/img/emoticon_$index.png',
        ),
      };
    });
  }

  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      this.image = image;
    });
  }

  void onSaveImage() async {
    RenderRepaintBoundary boundary =
        imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(); // 이미지로 변경
    ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png); // ➋ byte data로 형태 변경
    Uint8List pngBytes = byteData!.buffer.asUint8List(); // ➌ Unit8List로 형태 변경

    await ImageGallerySaver.saveImage(pngBytes, quality: 100);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('저장되었습니다!'),
      ),
    );
  }

  // 순회, 비교, 삭제
  void onDeleteItem() async {
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();
    });
  }

  // 변경 중인 스티커 -> 현재 스티커
  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }
}
