class GetSalesPickingListCLRMByAssignToUserAndVendorModel {
  num? id;
  num? assignToUserid;
  String? productName;
  num? quantity;
  num? productid;
  String? jobOrderNumber;
  String? transactionDate;
  String? created;
  num? vendorId;

  GetSalesPickingListCLRMByAssignToUserAndVendorModel(
      {this.id,
      this.assignToUserid,
      this.productName,
      this.quantity,
      this.productid,
      this.jobOrderNumber,
      this.transactionDate,
      this.created,
      this.vendorId});

  GetSalesPickingListCLRMByAssignToUserAndVendorModel.fromJson(
      Map<String, dynamic> json) {
    id = json['id'];
    assignToUserid = json['assign_to_userid'];
    productName = json['product_name'];
    quantity = json['quantity'];
    productid = json['productid'];
    jobOrderNumber = json['job_order_number'];
    transactionDate = json['transaction_date'];
    created = json['created'];
    vendorId = json['vendor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['assign_to_userid'] = assignToUserid;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['productid'] = productid;
    data['job_order_number'] = jobOrderNumber;
    data['transaction_date'] = transactionDate;
    data['created'] = created;
    data['vendor_id'] = vendorId;
    return data;
  }
}
