class StockMasterModel {
  String? id;
  String? itemCode;
  String? itemDesc;
  String? itemGroupId;
  String? groupName;
  String? gtin;
  String? mainLocation;
  String? binLocation;
  String? length;
  String? width;
  String? height;
  String? weight;
  int? prodLineId;
  int? prodBrandId;
  String? batchNo;
  String? expiryDate;
  String? manufactureDate;

  StockMasterModel({
    this.id,
    this.itemCode,
    this.itemDesc,
    this.itemGroupId,
    this.groupName,
    this.gtin,
    this.mainLocation,
    this.binLocation,
    this.length,
    this.width,
    this.height,
    this.weight,
    this.prodLineId,
    this.prodBrandId,
    this.batchNo,
    this.expiryDate,
    this.manufactureDate,
  });

  factory StockMasterModel.fromJson(Map<String, dynamic> json) {
    return StockMasterModel(
      id: json['id'],
      itemCode: json['ITEMID'],
      itemDesc: json['ITEMNAME'],
      itemGroupId: json['ITEMGROUPID'],
      groupName: json['GROUPNAME'],
      gtin: json['GTIN'],
      mainLocation: null,
      binLocation: null,
      length: json['Length']?.toString(),
      width: json['Width']?.toString(),
      height: json['Height']?.toString(),
      weight: json['Weight']?.toString(),
      prodLineId: json['PRODLINEID'] != null
          ? int.tryParse(json['PRODLINEID'].toString())
          : null,
      prodBrandId: json['PRODBRANDID'] != null
          ? int.tryParse(json['PRODBRANDID'].toString())
          : null,
      batchNo: json['BatchNo'],
      expiryDate: json['ExpiryDate'],
      manufactureDate: json['ManufactureDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['ITEMID'] = itemCode;
    data['ITEMNAME'] = itemDesc;
    data['ITEMGROUPID'] = itemGroupId;
    data['GROUPNAME'] = groupName;
    data['GTIN'] = gtin;
    data['Length'] = length;
    data['Width'] = width;
    data['Height'] = height;
    data['Weight'] = weight;
    data['PRODLINEID'] = prodLineId;
    data['PRODBRANDID'] = prodBrandId;
    data['BatchNo'] = batchNo;
    data['ExpiryDate'] = expiryDate;
    data['ManufactureDate'] = manufactureDate;
    return data;
  }
}
