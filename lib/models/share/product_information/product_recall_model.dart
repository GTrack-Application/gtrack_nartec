class ProductRecallModel {
  int? iD;
  String? productRecall;
  String? linkType;
  String? lang;
  String? targetURL;
  String? gTIN;
  String? expiryDate;

  ProductRecallModel(
      {this.iD,
      this.productRecall,
      this.linkType,
      this.lang,
      this.targetURL,
      this.gTIN,
      this.expiryDate});

  ProductRecallModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productRecall = json['ProductRecall'];
    linkType = json['LinkType'];
    lang = json['Lang'];
    targetURL = json['TargetURL'];
    gTIN = json['GTIN'];
    expiryDate = json['ExpiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['ProductRecall'] = productRecall;
    data['LinkType'] = linkType;
    data['Lang'] = lang;
    data['TargetURL'] = targetURL;
    data['GTIN'] = gTIN;
    data['ExpiryDate'] = expiryDate;
    return data;
  }
}
