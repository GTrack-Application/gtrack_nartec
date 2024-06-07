class AssetDetailsModel {
  String assetId;
  String tagNo;
  String description;
  String assetClass;
  String location;

  AssetDetailsModel({
    required this.assetId,
    required this.tagNo,
    required this.description,
    required this.assetClass,
    required this.location,
  });

  factory AssetDetailsModel.fromJson(Map<String, dynamic> json) {
    return AssetDetailsModel(
      assetId: json['assetId'],
      tagNo: json['tagNo'],
      description: json['description'],
      assetClass: json['assetClass'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'tagNo': tagNo,
      'description': description,
      'assetClass': assetClass,
      'location': location,
    };
  }
}
