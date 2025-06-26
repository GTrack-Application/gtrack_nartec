class PromotionalOfferModel {
  String? id;
  String? promotionalOffers;
  String? linkType;
  String? logo;
  String? lang;
  String? targetURL;
  String? gTIN;
  String? expiryDate;
  int? price;
  String? banner;
  String? companyId;
  String? createdAt;
  String? updatedAt;
  String? lastModifiedBy;
  String? domainName;
  bool? isDefault;

  PromotionalOfferModel(
      {this.id,
      this.promotionalOffers,
      this.linkType,
      this.logo,
      this.lang,
      this.targetURL,
      this.gTIN,
      this.expiryDate,
      this.price,
      this.banner,
      this.companyId,
      this.createdAt,
      this.updatedAt,
      this.lastModifiedBy,
      this.domainName,
      this.isDefault});

  PromotionalOfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promotionalOffers = json['PromotionalOffers'];
    linkType = json['LinkType'];
    logo = json['logo'];
    lang = json['Lang'];
    targetURL = json['TargetURL'];
    gTIN = json['GTIN'];
    expiryDate = json['ExpiryDate'];
    price = json['price'];
    banner = json['banner'];
    companyId = json['companyId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastModifiedBy = json['last_modified_by'];
    domainName = json['domainName'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PromotionalOffers'] = promotionalOffers;
    data['LinkType'] = linkType;
    data['logo'] = logo;
    data['Lang'] = lang;
    data['TargetURL'] = targetURL;
    data['GTIN'] = gTIN;
    data['ExpiryDate'] = expiryDate;
    data['price'] = price;
    data['banner'] = banner;
    data['companyId'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['last_modified_by'] = lastModifiedBy;
    data['domainName'] = domainName;
    data['is_default'] = isDefault;
    return data;
  }
}
