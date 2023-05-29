class StickerModel {
  final String id;
  final String imgPath;

  StickerModel({
    required this.id,
    required this.imgPath,
  });

  @override
  bool operator == (Object other) {
    return (other as StickerModel).id == id;
  }

  // 해시값을 사용하는 데이터 구조에서 사용하는 게터
  // id의 hasCode만 반환
  @override
  int get hashCode => id.hashCode;
}