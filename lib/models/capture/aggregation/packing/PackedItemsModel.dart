// ignore_for_file: file_names

class PackedItemsModel {
  String? id;
  String? gTIN;
  String? bATCH;
  String? manufacturingDate;
  String? userId;
  num? quantity;
  String? gLN;
  num? netWeight;
  String? unitOfMeasure;
  String? expiryDate;
  String? timestamp;
  String? itemImage;
  String? itemName;

  PackedItemsModel({
    this.id,
    this.gTIN,
    this.bATCH,
    this.manufacturingDate,
    this.userId,
    this.quantity,
    this.gLN,
    this.netWeight,
    this.unitOfMeasure,
    this.expiryDate,
    this.timestamp,
    this.itemImage,
    this.itemName,
  });

  PackedItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    gTIN = json['GTIN'].toString();
    bATCH = json['BATCH'].toString();
    manufacturingDate = json['ManufacturingDate'].toString();
    userId = json['User_id'].toString();
    quantity = json['Quantity'];
    gLN = json['GLN'].toString();
    netWeight = json['NetWeight'];
    unitOfMeasure = json['UnitOfMeasure'].toString();
    expiryDate = json['ExpiryDate'].toString();
    timestamp = json['Timestamp'].toString();
    itemImage = json['ItemImage'].toString();
    itemName = json['ItemName'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['GTIN'] = gTIN;
    data['BATCH'] = bATCH;
    data['ManufacturingDate'] = manufacturingDate;
    data['User_id'] = userId;
    data['Quantity'] = quantity;
    data['GLN'] = gLN;
    data['NetWeight'] = netWeight;
    data['UnitOfMeasure'] = unitOfMeasure;
    data['ExpiryDate'] = expiryDate;
    data['Timestamp'] = timestamp;
    data['ItemImage'] = itemImage;
    data['ItemName'] = itemName;
    return data;
  }
}
