class CountryModel {
  int? id;
  String? nameEn;
  String? nameAr;
  String? countryCode;
  String? countryShortName;
  String? status;
  String? createdAt;
  String? updatedAt;

  CountryModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.countryCode,
    this.countryShortName,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'].toString();
    nameAr = json['name_ar'].toString();
    countryCode = json['country_code'].toString();
    countryShortName = json['country_shortName'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_en'] = nameEn;
    data['name_ar'] = nameAr;
    data['country_code'] = countryCode;
    data['country_shortName'] = countryShortName;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
