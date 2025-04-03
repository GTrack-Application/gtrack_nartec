class StockMasterModel {
  String? itemCode;
  String? itemDesc;
  String? gtin;
  String? mainLocation;
  String? binLocation;
  String? length;
  String? width;
  String? height;
  String? weight;
  String? expiryDate;
  String? batchNo;

  StockMasterModel({
    this.itemCode,
    this.itemDesc,
    this.gtin,
    this.mainLocation,
    this.binLocation,
    this.length,
    this.width,
    this.height,
    this.weight,
    this.expiryDate,
    this.batchNo,
  });

  StockMasterModel.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemDesc = json['ItemDesc'];
    gtin = json['GTIN'];
    mainLocation = json['MainLocation'];
    binLocation = json['BinLocation'];
    length = json['Length']?.toString();
    width = json['Width']?.toString();
    height = json['Height']?.toString();
    weight = json['Weight']?.toString();
    expiryDate = json['ExpiryDate'];
    batchNo = json['BatchNo'];
  }

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
    data['ExpiryDate'] = expiryDate;
    data['BatchNo'] = batchNo;
    return data;
  }
}
