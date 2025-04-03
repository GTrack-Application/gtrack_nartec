class MappedBarcodeRequestModel {
  String itemCode;
  String itemDesc;
  String gtin;
  String mainLocation;
  String binLocation;
  double length;
  double width;
  double height;
  double weight;
  int trans;
  String expiryDate;
  String batchNo;

  MappedBarcodeRequestModel({
    required this.itemCode,
    required this.itemDesc,
    required this.gtin,
    required this.mainLocation,
    required this.binLocation,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.trans,
    required this.expiryDate,
    required this.batchNo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemCode'] = itemCode;
    data['ItemDesc'] = itemDesc;
    data['GTIN'] = gtin;
    data['MainLocation'] = mainLocation;
    data['BinLocation'] = binLocation;
    data['Length'] = length;
    data['Width'] = width;
    data['Height'] = height;
    data['Weight'] = weight;
    data['Trans'] = trans;
    data['ExpiryDate'] = expiryDate;
    data['BatchNo'] = batchNo;
    return data;
  }
}
