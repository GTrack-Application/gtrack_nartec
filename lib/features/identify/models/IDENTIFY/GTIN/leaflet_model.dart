class LeafletModel {
  final int id;
  final String productLeafletInformation;
  final String lang;
  final String linkType;
  final String targetUrl;
  final String gtin;
  final String pdfDoc;
  final dynamic companyId;

  LeafletModel({
    required this.id,
    required this.productLeafletInformation,
    required this.lang,
    required this.linkType,
    required this.targetUrl,
    required this.gtin,
    required this.pdfDoc,
    this.companyId,
  });

  factory LeafletModel.fromJson(Map<String, dynamic> json) {
    return LeafletModel(
      id: json['ID'],
      productLeafletInformation: json['ProductLeafletInformation'],
      lang: json['Lang'],
      linkType: json['LinkType'],
      targetUrl: json['TargetURL'],
      gtin: json['GTIN'],
      pdfDoc: json['PdfDoc'],
      companyId: json['companyId'],
    );
  }
}

class LeafletResponse {
  final List<LeafletModel> leaflets;
  final int totalPages;

  LeafletResponse({
    required this.leaflets,
    required this.totalPages,
  });

  factory LeafletResponse.fromJson(List<dynamic> json) {
    final leaflets = json.map((e) => LeafletModel.fromJson(e)).toList();
    return LeafletResponse(
      leaflets: leaflets,
      totalPages: 1, // Since pagination isn't implemented in the API yet
    );
  }
}
