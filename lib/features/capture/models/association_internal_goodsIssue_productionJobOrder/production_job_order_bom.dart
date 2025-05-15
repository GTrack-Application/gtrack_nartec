class ProductionJobOrderDetail {
  String? id;
  String? jobOrderDetailsId;
  String? productId;
  String? productName;
  String? productDescription;
  String? taskDescription;
  String? unitOfMeasure;
  int? quantity;
  int? quantityPicked;
  String? binLocation;
  String? status;
  String? price;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  JobOrderDetails? jobOrderDetails;

  ProductionJobOrderDetail(
      {this.id,
      this.jobOrderDetailsId,
      this.productId,
      this.productName,
      this.productDescription,
      this.taskDescription,
      this.unitOfMeasure,
      this.quantity,
      this.quantityPicked,
      this.binLocation,
      this.status,
      this.price,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.jobOrderDetails});

  ProductionJobOrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobOrderDetailsId = json['jobOrderDetailsId'];
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    taskDescription = json['taskDescription'];
    unitOfMeasure = json['unitOfMeasure'];
    quantity = int.tryParse(json['quantity'] ?? '0');
    quantityPicked = int.tryParse(json['quantityPicked'] ?? '0');
    binLocation = json['binLocation'];
    status = json['status'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    jobOrderDetails = json['JobOrderDetails'] != null
        ? JobOrderDetails.fromJson(json['JobOrderDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jobOrderDetailsId'] = jobOrderDetailsId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['taskDescription'] = taskDescription;
    data['unitOfMeasure'] = unitOfMeasure;
    data['quantity'] = quantity;
    data['quantityPicked'] = quantityPicked;
    data['binLocation'] = binLocation;
    data['status'] = status;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (jobOrderDetails != null) {
      data['JobOrderDetails'] = jobOrderDetails!.toJson();
    }
    return data;
  }

  ProductionJobOrderDetail copyWith({int? newQuantity}) {
    return ProductionJobOrderDetail(
        id: id,
        jobOrderDetailsId: jobOrderDetailsId,
        productId: productId,
        productName: productName,
        productDescription: productDescription,
        taskDescription: taskDescription,
        unitOfMeasure: unitOfMeasure,
        quantity: newQuantity,
        quantityPicked: quantityPicked,
        binLocation: binLocation,
        status: status,
        price: price,
        totalPrice: totalPrice,
        createdAt: createdAt,
        updatedAt: updatedAt,
        jobOrderDetails: jobOrderDetails);
  }

  ProductionJobOrderDetail increaseQuantity() {
    final newBom = ProductionJobOrderDetail(
      id: id,
      jobOrderDetailsId: jobOrderDetailsId,
      productId: productId,
      productName: productName,
      productDescription: productDescription,
      taskDescription: taskDescription,
      unitOfMeasure: unitOfMeasure,
      quantity: (quantity ?? 0) + 1,
      quantityPicked: quantityPicked,
      binLocation: binLocation,
      status: status,
      price: price,
      totalPrice: totalPrice,
      createdAt: createdAt,
      updatedAt: updatedAt,
      jobOrderDetails: jobOrderDetails,
    );
    return newBom;
  }

  ProductionJobOrderDetail increasePickedQuantity() {
    final newBom = ProductionJobOrderDetail(
      id: id,
      jobOrderDetailsId: jobOrderDetailsId,
      productId: productId,
      productName: productName,
      productDescription: productDescription,
      taskDescription: taskDescription,
      unitOfMeasure: unitOfMeasure,
      quantity: quantity,
      quantityPicked: (quantityPicked ?? 0) + 1,
      binLocation: binLocation,
      status: status,
      price: price,
      totalPrice: totalPrice,
      createdAt: createdAt,
      updatedAt: updatedAt,
      jobOrderDetails: jobOrderDetails,
    );
    return newBom;
  }
}

class JobOrderDetails {
  String? id;
  String? jobOrderId;
  String? productId;
  String? productName;
  String? productDescription;
  String? unitOfMeasure;
  int? quantity;
  String? price;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  String? subUserId;

  JobOrderDetails(
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
      this.subUserId});

  JobOrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobOrderId = json['jobOrderId'];
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    unitOfMeasure = json['unitOfMeasure'];
    quantity = int.tryParse(json['quantity'] ?? '0');
    price = json['price'];
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    subUserId = json['subUserId'];
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
    data['subUserId'] = subUserId;
    return data;
  }

  JobOrderDetails copyWith({int? quantity}) {
    return JobOrderDetails(
        id: id,
        jobOrderId: jobOrderId,
        productId: productId,
        productName: productName,
        productDescription: productDescription,
        unitOfMeasure: unitOfMeasure,
        quantity: quantity);
  }
}
