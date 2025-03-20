class StateModel {
  int? id;
  String? name;
  String? nameAr;
  String? countryId;
  String? createdAt;
  String? updatedAt;

  StateModel({
    this.id,
    this.name,
    this.nameAr,
    this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['country_id'] = countryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
