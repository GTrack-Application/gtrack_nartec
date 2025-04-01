class PalletNumberDetailsModel {
  String? id;
  String? expectedGoodsReceiptId;
  String? productId;
  String? productName;
  String? unitOfMeasure;
  num? quantity;
  num? receivedQuantity;
  String? itemType;
  String? palletNumber;
  String? barcode;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? netWeight;
  String? expiryDate;
  Count? cCount;

  PalletNumberDetailsModel({
    this.id,
    this.expectedGoodsReceiptId,
    this.productId,
    this.productName,
    this.unitOfMeasure,
    this.quantity,
    this.receivedQuantity,
    this.itemType,
    this.palletNumber,
    this.barcode,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.netWeight,
    this.expiryDate,
    this.cCount,
  });

  PalletNumberDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expectedGoodsReceiptId = json['expectedGoodsReceiptId'];
    productId = json['productId'];
    productName = json['productName'];
    unitOfMeasure = json['unitOfMeasure'];
    quantity = json['quantity'];
    receivedQuantity = json['receivedQuantity'];
    itemType = json['itemType'];
    palletNumber = json['palletNumber'];
    barcode = json['barcode'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    netWeight = json['netWeight'];
    expiryDate = json['expiryDate'];
    cCount = json['_count'] != null ? new Count.fromJson(json['_count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expectedGoodsReceiptId'] = expectedGoodsReceiptId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['unitOfMeasure'] = unitOfMeasure;
    data['quantity'] = quantity;
    data['receivedQuantity'] = receivedQuantity;
    data['itemType'] = itemType;
    data['palletNumber'] = palletNumber;
    data['barcode'] = barcode;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['netWeight'] = netWeight;
    data['expiryDate'] = expiryDate;
    if (cCount != null) {
      data['_count'] = cCount!.toJson();
    }
    return data;
  }
}

class Count {
  num? expectedGoodsReceiptSubdetails;

  Count({this.expectedGoodsReceiptSubdetails});

  Count.fromJson(Map<String, dynamic> json) {
    expectedGoodsReceiptSubdetails = json['ExpectedGoodsReceiptSubdetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ExpectedGoodsReceiptSubdetails'] = expectedGoodsReceiptSubdetails;
    return data;
  }
}
