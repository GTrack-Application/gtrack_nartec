class JobOrderModel {
  final String id;
  final String jobOrderId;
  final String jobOrderDetailsId;
  final String productId;
  final String productName;
  final String productDescription;
  final String unitOfMeasure;
  final String quantity;
  final String price;
  final String totalPrice;
  final DateTime pickedDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<JobOrderBillOfMaterial> billOfMaterials;

  JobOrderModel({
    required this.id,
    required this.jobOrderId,
    required this.jobOrderDetailsId,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.unitOfMeasure,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.pickedDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.billOfMaterials,
  });

  factory JobOrderModel.fromJson(Map<String, dynamic> json) {
    return JobOrderModel(
      id: json['id'] ?? '',
      jobOrderId: json['jobOrderId'] ?? '',
      jobOrderDetailsId: json['jobOrderDetailsId'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productDescription: json['productDescription'] ?? '',
      unitOfMeasure: json['unitOfMeasure'] ?? '',
      quantity: json['quantity'] ?? '',
      price: json['price'] ?? '',
      totalPrice: json['totalPrice'] ?? '',
      pickedDate: DateTime.parse(json['picked_date']),
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      billOfMaterials: (json['WIP_BillOfMaterial'] as List?)
              ?.map((e) => JobOrderBillOfMaterial.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class JobOrderBillOfMaterial {
  final String id;
  final String wipItemId;
  final String productId;
  final String productName;
  final String productDescription;
  final String? taskDescription;
  final String unitOfMeasure;
  final String quantity;
  final String quantityPicked;
  final String binLocation;
  final String status;
  final String price;
  final String totalPrice;
  int isSelected = -1;

  JobOrderBillOfMaterial({
    required this.id,
    required this.wipItemId,
    required this.productId,
    required this.productName,
    required this.productDescription,
    this.taskDescription,
    required this.unitOfMeasure,
    required this.quantity,
    required this.quantityPicked,
    required this.binLocation,
    required this.status,
    required this.price,
    required this.totalPrice,
    this.isSelected = -1,
  });

  factory JobOrderBillOfMaterial.fromJson(Map<String, dynamic> json) {
    return JobOrderBillOfMaterial(
      id: json['id'] ?? '',
      wipItemId: json['wipItemId'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productDescription: json['productDescription'] ?? '',
      taskDescription: json['taskDescription'],
      unitOfMeasure: json['unitOfMeasure'] ?? '',
      quantity: json['quantity'] ?? '',
      quantityPicked: json['quantityPicked'] ?? '',
      binLocation: json['binLocation'] ?? '',
      status: json['status'] ?? '',
      price: json['price'] ?? '',
      totalPrice: json['totalPrice'] ?? '',
      isSelected: -1,
    );
  }
}
