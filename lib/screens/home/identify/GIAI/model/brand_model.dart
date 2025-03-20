class BrandModel {
  final String? id;
  final String? name;
  final String? mainCode;
  final String? majorCode;
  final String? giaiCategoryId;
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

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      mainCode: json['mainCode']?.toString(),
      majorCode: json['majorCode']?.toString(),
      giaiCategoryId: json['giaiCategoryId']?.toString(),
    );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BrandModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
