class LocationOriginModel {
  int? iD;
  String? productLocationOrigin;
  String? linkType;
  String? lang;
  String? targetURL;
  String? gTIN;
  String? expiryDate;

  LocationOriginModel(
      {this.iD,
      this.productLocationOrigin,
      this.linkType,
      this.lang,
      this.targetURL,
      this.gTIN,
      this.expiryDate});

  LocationOriginModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productLocationOrigin = json['ProductLocationOrigin'];
    linkType = json['LinkType'];
    lang = json['Lang'];
    targetURL = json['TargetURL'];
    gTIN = json['GTIN'];
    expiryDate = json['ExpiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['ProductLocationOrigin'] = productLocationOrigin;
    data['LinkType'] = linkType;
    data['Lang'] = lang;
    data['TargetURL'] = targetURL;
    data['GTIN'] = gTIN;
    data['ExpiryDate'] = expiryDate;
    return data;
  }
}
