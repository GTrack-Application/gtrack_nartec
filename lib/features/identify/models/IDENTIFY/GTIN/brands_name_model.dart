class BrandsNameModel {
  String? id;
  String? name;
  String? nameAr;
  String? status;
  String? userId;
  String? createdAt;
  String? updatedAt;
  String? companyID;
  String? brandCertificate;

  BrandsNameModel(
      {this.id,
      this.name,
      this.nameAr,
      this.status,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.companyID,
      this.brandCertificate});

  BrandsNameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyID = json['companyID'];
    brandCertificate = json['brand_certificate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['status'] = status;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['companyID'] = companyID;
    data['brand_certificate'] = brandCertificate;
    return data;
  }
}
