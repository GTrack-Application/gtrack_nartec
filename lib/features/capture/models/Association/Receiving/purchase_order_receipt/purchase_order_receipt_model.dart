class PurchaseOrderReceiptModel {
  String? id;
  String? purchaseOrderNumber;
  String? memberId;
  String? supplierId;
  String? orderDate;
  String? deliveryDate;
  String? totalAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic gdti;
  dynamic popath;
  List<GRNPurchaseOrderItem>? gRNPurchaseOrderItem;

  PurchaseOrderReceiptModel({
    this.id,
    this.purchaseOrderNumber,
    this.memberId,
    this.supplierId,
    this.orderDate,
    this.deliveryDate,
    this.totalAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.gdti,
    this.popath,
    this.gRNPurchaseOrderItem,
  });

  PurchaseOrderReceiptModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    purchaseOrderNumber = json['purchaseOrderNumber'];
    memberId = json['member_id'];
    supplierId = json['supplier_id'];
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    gdti = json['gdti'];
    popath = json['popath'];
    if (json['GRNPurchaseOrderItem'] != null) {
      gRNPurchaseOrderItem = <GRNPurchaseOrderItem>[];
      json['GRNPurchaseOrderItem'].forEach((v) {
        gRNPurchaseOrderItem!.add(new GRNPurchaseOrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['purchaseOrderNumber'] = purchaseOrderNumber;
    data['member_id'] = memberId;
    data['supplier_id'] = supplierId;
    data['orderDate'] = orderDate;
    data['deliveryDate'] = deliveryDate;
    data['totalAmount'] = totalAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['gdti'] = gdti;
    data['popath'] = popath;
    if (gRNPurchaseOrderItem != null) {
      data['GRNPurchaseOrderItem'] =
          gRNPurchaseOrderItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GRNPurchaseOrderItem {
  String? id;
  String? grnPurchaseOrderId;
  String? productId;
  String? productName;
  String? productDescription;
  String? unitOfMeasure;
  String? quantityOrdered;
  num? quantityReceived;
  String? price;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;

  GRNPurchaseOrderItem({
    this.id,
    this.grnPurchaseOrderId,
    this.productId,
    this.productName,
    this.productDescription,
    this.unitOfMeasure,
    this.quantityOrdered,
    this.quantityReceived,
    this.price,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
  });

  GRNPurchaseOrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grnPurchaseOrderId = json['grnPurchaseOrderId'];
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    unitOfMeasure = json['unitOfMeasure'];
    quantityOrdered = json['quantityOrdered'];
    quantityReceived = json['quantityReceived'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['grnPurchaseOrderId'] = grnPurchaseOrderId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['unitOfMeasure'] = unitOfMeasure;
    data['quantityOrdered'] = quantityOrdered;
    data['quantityReceived'] = quantityReceived;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
