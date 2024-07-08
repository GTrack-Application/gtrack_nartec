class ProductTypeModel {
  String? id;
  String? name;
  String? nameAr;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProductTypeModel(
      {this.id,
      this.name,
      this.nameAr,
      this.status,
      this.createdAt,
      this.updatedAt});

  ProductTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
