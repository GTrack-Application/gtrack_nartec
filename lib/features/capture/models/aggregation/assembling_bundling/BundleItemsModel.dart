// ignore_for_file: file_names

class BundleItemsModel {
  String? userId;
  String? gtin;
  String? location;
  String? bundlingName;

  BundleItemsModel({this.userId, this.gtin, this.location, this.bundlingName});

  BundleItemsModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    gtin = json['GTIN'];
    location = json['location'];
    bundlingName = json['bundling_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['GTIN'] = gtin;
    data['location'] = location;
    data['bundling_name'] = bundlingName;
    return data;
  }
}

class AssembleItemsModel {
  String? userId;
  String? gtin;
  String? location;
  String? bundlingName;

  AssembleItemsModel(
      {this.userId, this.gtin, this.location, this.bundlingName});

  AssembleItemsModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    gtin = json['GTIN'];
    location = json['location'];
    bundlingName = json['assembling_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['GTIN'] = gtin;
    data['location'] = location;
    data['bundling_name'] = bundlingName;
    return data;
  }
}
