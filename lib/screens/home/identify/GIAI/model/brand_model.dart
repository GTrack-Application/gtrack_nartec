class BrandModel {
  String? id;
  String? name;
  String? mainCode;
  String? majorCode;
  String? giaiCategoryId;
  String? createdAt;
  String? updatedAt;

  BrandModel({
    this.id,
    this.name,
    this.mainCode,
    this.majorCode,
    this.giaiCategoryId,
    this.createdAt,
    this.updatedAt,
  });

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainCode = json['mainCode'];
    majorCode = json['majorCode'];
    giaiCategoryId = json['giaiCategoryId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mainCode'] = mainCode;
    data['majorCode'] = majorCode;
    data['giaiCategoryId'] = giaiCategoryId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
