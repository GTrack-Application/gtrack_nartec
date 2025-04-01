class SubSalesOrderModel {
  String? id;
  String? salesInvoiceId;
  String? productId;
  String? productName;
  String? productDescription;
  String? unitOfMeasure;
  num? quantity;
  num? quantityPicked;
  String? price;
  String? totalPrice;
  String? images;
  String? createdAt;
  String? updatedAt;
  SalesInvoiceMaster? salesInvoiceMaster;

  SubSalesOrderModel({
    this.id,
    this.salesInvoiceId,
    this.productId,
    this.productName,
    this.productDescription,
    this.unitOfMeasure,
    this.quantity,
    this.quantityPicked,
    this.price,
    this.totalPrice,
    this.images,
    this.createdAt,
    this.updatedAt,
    this.salesInvoiceMaster,
  });

  SubSalesOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesInvoiceId = json['salesInvoiceId'];
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    unitOfMeasure = json['unitOfMeasure'];
    quantity = num.tryParse(json['quantity'].toString()) ?? 0;
    quantityPicked = json['quantityPicked'] ?? 0;
    price = json['price'];
    totalPrice = json['totalPrice'];
    images = json['images'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    salesInvoiceMaster = json['SalesInvoiceMaster'] != null
        ? SalesInvoiceMaster.fromJson(json['SalesInvoiceMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salesInvoiceId'] = salesInvoiceId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['unitOfMeasure'] = unitOfMeasure;
    data['quantity'] = quantity;
    data['quantityPicked'] = quantityPicked;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (salesInvoiceMaster != null) {
      data['SalesInvoiceMaster'] = salesInvoiceMaster!.toJson();
    }
    return data;
  }

  SubSalesOrderModel increasePickedQuantity() {
    return SubSalesOrderModel(
      id: id,
      salesInvoiceId: salesInvoiceId,
      productId: productId,
      productName: productName,
      productDescription: productDescription,
      unitOfMeasure: unitOfMeasure,
      quantity: quantity,
      quantityPicked: (quantityPicked ?? 0) + 1,
      price: price,
      totalPrice: totalPrice,
      images: images,
      createdAt: createdAt,
      updatedAt: updatedAt,
      salesInvoiceMaster: salesInvoiceMaster,
    );
  }
}

class SalesInvoiceMaster {
  String? id;
  String? salesInvoiceNumber;
  String? purchaseOrderNumber;
  String? customerId;
  String? orderDate;
  String? deliveryDate;
  String? totalAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? memberId;
  String? subUserId;
  String? signature;
  String? assignedTime;
  String? startJourneyTime;
  String? arrivalTime;
  String? unloadingTime;
  String? invoiceCreationTime;
  String? endJourneyTime;
  String? pickDate;

  SalesInvoiceMaster({
    this.id,
    this.salesInvoiceNumber,
    this.purchaseOrderNumber,
    this.customerId,
    this.orderDate,
    this.deliveryDate,
    this.totalAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.memberId,
    this.subUserId,
    this.signature,
    this.assignedTime,
    this.startJourneyTime,
    this.arrivalTime,
    this.unloadingTime,
    this.invoiceCreationTime,
    this.endJourneyTime,
    this.pickDate,
  });

  SalesInvoiceMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesInvoiceNumber = json['salesInvoiceNumber'];
    purchaseOrderNumber = json['purchaseOrderNumber'];
    customerId = json['customerId'];
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberId = json['memberId'];
    subUserId = json['subUser_id'];
    signature = json['signature'];
    assignedTime = json['assignedTime'];
    startJourneyTime = json['startJourneyTime'];
    arrivalTime = json['arrivalTime'];
    unloadingTime = json['unloadingTime'];
    invoiceCreationTime = json['invoiceCreationTime'];
    endJourneyTime = json['endJourneyTime'];
    pickDate = json['pickDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salesInvoiceNumber'] = salesInvoiceNumber;
    data['purchaseOrderNumber'] = purchaseOrderNumber;
    data['customerId'] = customerId;
    data['orderDate'] = orderDate;
    data['deliveryDate'] = deliveryDate;
    data['totalAmount'] = totalAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['memberId'] = memberId;
    data['subUser_id'] = subUserId;
    data['signature'] = signature;
    data['assignedTime'] = assignedTime;
    data['startJourneyTime'] = startJourneyTime;
    data['arrivalTime'] = arrivalTime;
    data['unloadingTime'] = unloadingTime;
    data['invoiceCreationTime'] = invoiceCreationTime;
    data['endJourneyTime'] = endJourneyTime;
    data['pickDate'] = pickDate;
    return data;
  }
}
