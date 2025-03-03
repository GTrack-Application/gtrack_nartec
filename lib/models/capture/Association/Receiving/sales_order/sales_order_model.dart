class SalesOrderModel {
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
  dynamic signature;
  String? assignedTime;
  dynamic startJourneyTime;
  dynamic arrivalTime;
  dynamic unloadingTime;
  dynamic invoiceCreationTime;
  dynamic endJourneyTime;
  dynamic pickDate;

  SalesOrderModel({
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

  SalesOrderModel.fromJson(Map<String, dynamic> json) {
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
