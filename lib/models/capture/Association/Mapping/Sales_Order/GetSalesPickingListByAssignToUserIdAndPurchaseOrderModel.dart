// ignore_for_file: file_names

class GetSalesPickingListByAssignToUserIdAndPurchaseOrderModel {
  num? id;
  num? poDetailId;
  num? poHeaderId;
  num? assignToUserId;
  num? vendorId;
  String? purchaseOrder;
  num? memberId;
  String? createDate;
  num? supplierId;
  String? productName;
  num? quantity;
  num? price;
  num? priceSubtotal;
  num? priceTotal;
  String? dateOrder;
  String? state;
  String? partnerName;

  GetSalesPickingListByAssignToUserIdAndPurchaseOrderModel(
      {this.id,
      this.poDetailId,
      this.poHeaderId,
      this.assignToUserId,
      this.vendorId,
      this.purchaseOrder,
      this.memberId,
      this.createDate,
      this.supplierId,
      this.productName,
      this.quantity,
      this.price,
      this.priceSubtotal,
      this.priceTotal,
      this.dateOrder,
      this.state,
      this.partnerName});

  GetSalesPickingListByAssignToUserIdAndPurchaseOrderModel.fromJson(
      Map<String, dynamic> json) {
    id = json['id'];
    poDetailId = json['po_detail_id'];
    poHeaderId = json['po_header_id'];
    assignToUserId = json['assign_to_user_id'];
    vendorId = json['vendor_id'];
    purchaseOrder = json['purchase_order'];
    memberId = json['member_id'];
    createDate = json['create_date'];
    supplierId = json['supplier_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    price = json['price'];
    priceSubtotal = json['price_subtotal'];
    priceTotal = json['price_total'];
    dateOrder = json['date_order'];
    state = json['state'];
    partnerName = json['partner_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['po_detail_id'] = poDetailId;
    data['po_header_id'] = poHeaderId;
    data['assign_to_user_id'] = assignToUserId;
    data['vendor_id'] = vendorId;
    data['purchase_order'] = purchaseOrder;
    data['member_id'] = memberId;
    data['create_date'] = createDate;
    data['supplier_id'] = supplierId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['price_subtotal'] = priceSubtotal;
    data['price_total'] = priceTotal;
    data['date_order'] = dateOrder;
    data['state'] = state;
    data['partner_name'] = partnerName;
    return data;
  }
}
