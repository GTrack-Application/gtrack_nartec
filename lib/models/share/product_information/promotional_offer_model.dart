class PromotionalOfferModel {
  int? iD;
  String? promotionalOffers;
  String? linkType;
  String? lang;
  String? targetURL;
  String? gTIN;
  String? expiryDate;
  int? price;
  String? banner;

  PromotionalOfferModel(
      {this.iD,
      this.promotionalOffers,
      this.linkType,
      this.lang,
      this.targetURL,
      this.gTIN,
      this.expiryDate,
      this.price,
      this.banner});

  PromotionalOfferModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    promotionalOffers = json['PromotionalOffers'];
    linkType = json['LinkType'];
    lang = json['Lang'];
    targetURL = json['TargetURL'];
    gTIN = json['GTIN'];
    expiryDate = json['ExpiryDate'];
    price = json['price'];
    banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['PromotionalOffers'] = promotionalOffers;
    data['LinkType'] = linkType;
    data['Lang'] = lang;
    data['TargetURL'] = targetURL;
    data['GTIN'] = gTIN;
    data['ExpiryDate'] = expiryDate;
    data['price'] = price;
    data['banner'] = banner;
    return data;
  }
}
