// ignore_for_file: file_names

class PackedItemsModel {
  int? id;
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
    id = json['id'];
    gTIN = json['GTIN'];
    bATCH = json['BATCH'];
    manufacturingDate = json['ManufacturingDate'];
    userId = json['User_id'];
    quantity = json['Quantity'];
    gLN = json['GLN'];
    netWeight = json['NetWeight'];
    unitOfMeasure = json['UnitOfMeasure'];
    expiryDate = json['ExpiryDate'];
    timestamp = json['Timestamp'];
    itemImage = json['ItemImage'];
    itemName = json['ItemName'];
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
