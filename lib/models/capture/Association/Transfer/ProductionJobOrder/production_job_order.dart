class ProductionJobOrder {
  String? id;
  String? jobOrderId;
  String? productId;
  String? productName;
  String? productDescription;
  String? unitOfMeasure;
  String? quantity;
  String? price;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  // Null? subUserId;
  // List<Null>? billOfMaterial;
  // Null? memberSubUsers;
  JobOrderMaster? jobOrderMaster;

  ProductionJobOrder(
      {this.id,
      this.jobOrderId,
      this.productId,
      this.productName,
      this.productDescription,
      this.unitOfMeasure,
      this.quantity,
      this.price,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      // this.subUserId,
      // this.billOfMaterial,
      // this.memberSubUsers,
      this.jobOrderMaster});

  ProductionJobOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobOrderId = json['jobOrderId'];
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    unitOfMeasure = json['unitOfMeasure'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // subUserId = json['subUserId'];
    // if (json['BillOfMaterial'] != null) {
    //   billOfMaterial = <Null>[];
    //   json['BillOfMaterial'].forEach((v) {
    //     billOfMaterial!.add(new Null.fromJson(v));
    //   });
    // }
    // memberSubUsers = json['MemberSubUsers'];
    jobOrderMaster = json['JobOrderMaster'] != null
        ? JobOrderMaster.fromJson(json['JobOrderMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jobOrderId'] = jobOrderId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['unitOfMeasure'] = unitOfMeasure;
    data['quantity'] = quantity;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    // data['subUserId'] = this.subUserId;
    // if (this.billOfMaterial != null) {
    //   data['BillOfMaterial'] =
    //       this.billOfMaterial!.map((v) => v.toJson()).toList();
    // }
    // data['MemberSubUsers'] = this.memberSubUsers;
    if (jobOrderMaster != null) {
      data['JobOrderMaster'] = jobOrderMaster!.toJson();
    }
    return data;
  }
}

class JobOrderMaster {
  String? id;
  String? jobOrderNumber;
  // Null? purchaseOrderNumber;
  String? customerId;
  String? memberId;
  String? jobStartDate;
  String? jobEndDate;
  String? orderDate;
  String? deliveryDate;
  String? totalCost;
  String? status;
  String? jobDescription;
  String? remarks;
  String? createdAt;
  String? updatedAt;

  JobOrderMaster(
      {this.id,
      this.jobOrderNumber,
      // this.purchaseOrderNumber,
      this.customerId,
      this.memberId,
      this.jobStartDate,
      this.jobEndDate,
      this.orderDate,
      this.deliveryDate,
      this.totalCost,
      this.status,
      this.jobDescription,
      this.remarks,
      this.createdAt,
      this.updatedAt});

  JobOrderMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobOrderNumber = json['jobOrderNumber'];
    // purchaseOrderNumber = json['purchaseOrderNumber'];
    customerId = json['customerId'];
    memberId = json['memberId'];
    jobStartDate = json['jobStartDate'];
    jobEndDate = json['jobEndDate'];
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'];
    totalCost = json['totalCost'];
    status = json['status'];
    jobDescription = json['jobDescription'];
    remarks = json['remarks'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jobOrderNumber'] = jobOrderNumber;
    // data['purchaseOrderNumber'] = this.purchaseOrderNumber;
    data['customerId'] = customerId;
    data['memberId'] = memberId;
    data['jobStartDate'] = jobStartDate;
    data['jobEndDate'] = jobEndDate;
    data['orderDate'] = orderDate;
    data['deliveryDate'] = deliveryDate;
    data['totalCost'] = totalCost;
    data['status'] = status;
    data['jobDescription'] = jobDescription;
    data['remarks'] = remarks;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
