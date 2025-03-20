class CityModel {
  int? id;
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
    name = json['name'].toString();
    nameAr = json['name_ar'].toString();
    stateId = json['state_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
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
