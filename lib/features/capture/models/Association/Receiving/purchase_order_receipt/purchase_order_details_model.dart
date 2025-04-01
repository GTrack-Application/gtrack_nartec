class PurchaseOrderDetailsModel {
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
  String? gdti;
  String? popath;
  List<PurchaseOrderDetails>? purchaseOrderDetails;

  PurchaseOrderDetailsModel({
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
    this.purchaseOrderDetails,
  });

  PurchaseOrderDetailsModel.fromJson(Map<String, dynamic> json) {
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
    if (json['PurchaseOrderDetails'] != null) {
      purchaseOrderDetails = <PurchaseOrderDetails>[];
      json['PurchaseOrderDetails'].forEach((v) {
        purchaseOrderDetails!.add(PurchaseOrderDetails.fromJson(v));
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
    if (purchaseOrderDetails != null) {
      data['PurchaseOrderDetails'] =
          purchaseOrderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PurchaseOrderDetails {
  String? id;
  String? purchaseOrderId;
  String? productId;
  String? productName;
  String? productDescription;
  String? unitOfMeasure;
  String? quantity;
  String? price;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;

  PurchaseOrderDetails({
    this.id,
    this.purchaseOrderId,
    this.productId,
    this.productName,
    this.productDescription,
    this.unitOfMeasure,
    this.quantity,
    this.price,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
  });

  PurchaseOrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    purchaseOrderId = json['purchaseOrderId'];
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    unitOfMeasure = json['unitOfMeasure'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['purchaseOrderId'] = purchaseOrderId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['unitOfMeasure'] = unitOfMeasure;
    data['quantity'] = quantity;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
