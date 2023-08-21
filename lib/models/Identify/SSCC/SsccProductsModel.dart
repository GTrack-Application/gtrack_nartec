class SsccProductsModel {
  int? ssccId;
  String? type;
  String? sSCCBarcodeNumber;

  SsccProductsModel({this.ssccId, this.type, this.sSCCBarcodeNumber});

  SsccProductsModel.fromJson(Map<String, dynamic> json) {
    ssccId = json['sscc_id'];
    type = json['Type'];
    sSCCBarcodeNumber = json['SSCCBarcodeNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sscc_id'] = ssccId;
    data['Type'] = type;
    data['SSCCBarcodeNumber'] = sSCCBarcodeNumber;
    return data;
  }
}
