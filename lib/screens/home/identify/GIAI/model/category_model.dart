class CategoryModel {
  String? id;
  String? mainCategoryCode;
  String? memberId;
  String? subCategoryCode;
  int? mainSubSeriesCounter;
  String? mainDescription;
  String? subDescription;
  String? seriesNumber;
  String? createdAt;
  String? updatedAt;

  CategoryModel({
    this.id,
    this.mainCategoryCode,
    this.memberId,
    this.subCategoryCode,
    this.mainSubSeriesCounter,
    this.mainDescription,
    this.subDescription,
    this.seriesNumber,
    this.createdAt,
    this.updatedAt,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainCategoryCode = json['mainCategoryCode'];
    memberId = json['memberId'];
    subCategoryCode = json['subCategoryCode'];
    mainSubSeriesCounter = json['mainSubSeriesCounter'];
    mainDescription = json['mainDescription'];
    subDescription = json['subDescription'];
    seriesNumber = json['seriesNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainCategoryCode'] = mainCategoryCode;
    data['memberId'] = memberId;
    data['subCategoryCode'] = subCategoryCode;
    data['mainSubSeriesCounter'] = mainSubSeriesCounter;
    data['mainDescription'] = mainDescription;
    data['subDescription'] = subDescription;
    data['seriesNumber'] = seriesNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
