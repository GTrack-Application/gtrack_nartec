class CityModel {
  String? id;
  String? name;
  String? nameAr;
  String? stateId;
  String? createdAt;
  String? updatedAt;

  CityModel({
    this.id,
    this.name,
    this.nameAr,
    this.stateId,
    this.createdAt,
    this.updatedAt,
  });

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    stateId = json['state_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['state_id'] = stateId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
