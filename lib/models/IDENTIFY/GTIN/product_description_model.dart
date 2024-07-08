class ProductDescriptionModel {
  String? id;
  String? languageCode;
  String? alpha3;
  String? iso6392B;
  String? languageName;
  String? createdAt;
  String? updatedAt;

  ProductDescriptionModel(
      {this.id,
      this.languageCode,
      this.alpha3,
      this.iso6392B,
      this.languageName,
      this.createdAt,
      this.updatedAt});

  ProductDescriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageCode = json['language_code'];
    alpha3 = json['alpha3'];
    iso6392B = json['iso639_2B'];
    languageName = json['language_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language_code'] = languageCode;
    data['alpha3'] = alpha3;
    data['iso639_2B'] = iso6392B;
    data['language_name'] = languageName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
