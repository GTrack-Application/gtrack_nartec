// ignore_for_file: file_names

class UnitListModel {
  String? id;
  String? unitCode;
  String? unitName;
  int? status;
  String? createdAt;
  String? updatedAt;

  UnitListModel({
    this.id,
    this.unitCode,
    this.unitName,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  UnitListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitCode = json['unit_code'];
    unitName = json['unit_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit_code'] = unitCode;
    data['unit_name'] = unitName;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
