class RetailerModel {
  String? id;
  String? productSku;
  String? barcode;
  String? storeId;
  String? storeName;
  String? storeGln;
  String? logo;
  String? createdAt;
  String? updatedAt;
  String? brandOwnerId;
  String? lastModifiedBy;
  String? domainName;

  RetailerModel(
      {this.id,
      this.productSku,
      this.barcode,
      this.storeId,
      this.storeName,
      this.storeGln,
      this.logo,
      this.createdAt,
      this.updatedAt,
      this.brandOwnerId,
      this.lastModifiedBy,
      this.domainName});

  RetailerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productSku = json['product_sku'];
    barcode = json['barcode'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    storeGln = json['store_gln'];
    logo = json['logo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    brandOwnerId = json['brand_owner_id'];
    lastModifiedBy = json['last_modified_by'];
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_sku'] = productSku;
    data['barcode'] = barcode;
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['store_gln'] = storeGln;
    data['logo'] = logo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['brand_owner_id'] = brandOwnerId;
    data['last_modified_by'] = lastModifiedBy;
    data['domainName'] = domainName;
    return data;
  }
}
