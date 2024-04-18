// ignore_for_file: file_names

class SearchGpcForCodification {
  String? segmentCode;
  String? segmentTitle;
  String? familyCode;
  String? familyTitle;
  String? classCode;
  String? classTitle;
  String? brickCode;
  String? brickTitle;

  SearchGpcForCodification({
    this.segmentCode,
    this.segmentTitle,
    this.familyCode,
    this.familyTitle,
    this.classCode,
    this.classTitle,
    this.brickCode,
    this.brickTitle,
  });

  SearchGpcForCodification.fromJson(Map<String, dynamic> json) {
    segmentCode = json['SegmentCode'];
    segmentTitle = json['SegmentTitle'];
    familyCode = json['FamilyCode'];
    familyTitle = json['FamilyTitle'];
    classCode = json['ClassCode'];
    classTitle = json['ClassTitle'];
    brickCode = json['BrickCode'];
    brickTitle = json['BrickTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SegmentCode'] = segmentCode;
    data['SegmentTitle'] = segmentTitle;
    data['FamilyCode'] = familyCode;
    data['FamilyTitle'] = familyTitle;
    data['ClassCode'] = classCode;
    data['ClassTitle'] = classTitle;
    data['BrickCode'] = brickCode;
    data['BrickTitle'] = brickTitle;
    return data;
  }
}
