class LeafletModel {
  int? iD;
  String? productLeafletInformation;
  String? lang;
  String? linkType;
  String? targetURL;
  String? gTIN;
  String? pdfDoc;
  String? companyId;

  LeafletModel({
    this.iD,
    this.productLeafletInformation,
    this.lang,
    this.linkType,
    this.targetURL,
    this.gTIN,
    this.pdfDoc,
    this.companyId,
  });

  LeafletModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productLeafletInformation = json['ProductLeafletInformation'];
    lang = json['Lang'];
    linkType = json['LinkType'];
    targetURL = json['TargetURL'];
    gTIN = json['GTIN'];
    pdfDoc = json['PdfDoc'];
    companyId = json['companyId'].toString();
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
    data['companyId'] = companyId;
    return data;
  }
}
