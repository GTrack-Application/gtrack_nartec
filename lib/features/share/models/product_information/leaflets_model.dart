class LeafletsModel {
  int? iD;
  String? productLeafletInformation;
  String? lang;
  String? linkType;
  String? targetURL;
  String? gTIN;
  String? pdfDoc;

  LeafletsModel(
      {this.iD,
      this.productLeafletInformation,
      this.lang,
      this.linkType,
      this.targetURL,
      this.gTIN,
      this.pdfDoc});

  LeafletsModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productLeafletInformation = json['ProductLeafletInformation'];
    lang = json['Lang'];
    linkType = json['LinkType'];
    targetURL = json['TargetURL'];
    gTIN = json['GTIN'];
    pdfDoc = json['PdfDoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['ProductLeafletInformation'] = productLeafletInformation;
    data['Lang'] = lang;
    data['LinkType'] = linkType;
    data['TargetURL'] = targetURL;
    data['GTIN'] = gTIN;
    data['PdfDoc'] = pdfDoc;
    return data;
  }
}
