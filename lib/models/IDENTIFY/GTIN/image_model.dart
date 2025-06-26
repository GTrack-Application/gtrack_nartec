class ImageModel {
  String? id;
  String? barcode;
  String? photos;
  String? createdAt;
  String? updatedAt;
  String? brandOwnerId;
  String? lastModifiedBy;
  String? domainName;

  ImageModel({
    this.id,
    this.barcode,
    this.photos,
    this.createdAt,
    this.updatedAt,
    this.brandOwnerId,
    this.lastModifiedBy,
    this.domainName,
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barcode = json['barcode'];
    photos = json['photos'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    brandOwnerId = json['brand_owner_id'];
    lastModifiedBy = json['last_modified_by'];
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['barcode'] = barcode;
    data['photos'] = photos;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['brand_owner_id'] = brandOwnerId;
    data['last_modified_by'] = lastModifiedBy;
    data['domainName'] = domainName;
    return data;
  }
}
