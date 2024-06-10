// ignore_for_file: file_names

class CountryListModel {
  String? id;
  String? alpha2;
  String? alpha3;
  String? countryCodeNumeric3;
  String? countryName;
  String? createdAt;
  String? updatedAt;

  CountryListModel({
    this.id,
    this.alpha2,
    this.alpha3,
    this.countryCodeNumeric3,
    this.countryName,
    this.createdAt,
    this.updatedAt,
  });

  CountryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alpha2 = json['Alpha2'];
    alpha3 = json['Alpha3'];
    countryCodeNumeric3 = json['country_code_numeric3'];
    countryName = json['country_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Alpha2'] = alpha2;
    data['Alpha3'] = alpha3;
    data['country_code_numeric3'] = countryCodeNumeric3;
    data['country_name'] = countryName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
