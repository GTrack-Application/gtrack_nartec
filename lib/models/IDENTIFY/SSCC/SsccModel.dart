// ignore_for_file: file_names

class SsccModel {
  String? id;
  String? ssccType;
  String? productId;
  String? referenceId;
  String? vendorID;
  String? vendorName;
  String? productID;
  String? description;
  String? serialNumber;
  String? itemCode;
  String? qty;
  String? useBy;
  String? batchNo;
  String? boxof;
  String? hsnSku;
  String? poNo;
  String? expiratonDate;
  String? shipTo;
  String? shipDate;
  String? vendorItemNo;
  String? shortQtyCode;
  String? countryId;
  String? carton;
  String? sSCCBarcodeNumber;
  String? sSCCBarcodeNumberWithoutCheck;
  String? userId;
  String? createdAt;
  String? updatedAt;
  String? gcpGLNID;
  String? deletedAt;

  SsccModel(
      {this.id,
      this.ssccType,
      this.productId,
      this.referenceId,
      this.vendorID,
      this.vendorName,
      this.productID,
      this.description,
      this.serialNumber,
      this.itemCode,
      this.qty,
      this.useBy,
      this.batchNo,
      this.boxof,
      this.hsnSku,
      this.poNo,
      this.expiratonDate,
      this.shipTo,
      this.shipDate,
      this.vendorItemNo,
      this.shortQtyCode,
      this.countryId,
      this.carton,
      this.sSCCBarcodeNumber,
      this.sSCCBarcodeNumberWithoutCheck,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.gcpGLNID,
      this.deletedAt});

  SsccModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ssccType = json['sscc_type'];
    productId = json['product_id'];
    referenceId = json['reference_id'];
    vendorID = json['VendorID'];
    vendorName = json['VendorName'];
    productID = json['productID'];
    description = json['description'];
    serialNumber = json['SerialNumber'];
    itemCode = json['ItemCode'];
    qty = json['Qty'];
    useBy = json['UseBy'];
    batchNo = json['BatchNo'];
    boxof = json['Boxof'];
    hsnSku = json['hsn_sku'];
    poNo = json['po_no'];
    expiratonDate = json['expiraton_date'];
    shipTo = json['ship_to'];
    shipDate = json['ship_date'];
    vendorItemNo = json['vendor_item_no'];
    shortQtyCode = json['short_qty_code'];
    countryId = json['country_id'];
    carton = json['carton'];
    sSCCBarcodeNumber = json['SSCCBarcodeNumber'];
    sSCCBarcodeNumberWithoutCheck = json['SSCCBarcodeNumber_without_check'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    gcpGLNID = json['gcpGLNID'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sscc_type'] = ssccType;
    data['product_id'] = productId;
    data['reference_id'] = referenceId;
    data['VendorID'] = vendorID;
    data['VendorName'] = vendorName;
    data['productID'] = productID;
    data['description'] = description;
    data['SerialNumber'] = serialNumber;
    data['ItemCode'] = itemCode;
    data['Qty'] = qty;
    data['UseBy'] = useBy;
    data['BatchNo'] = batchNo;
    data['Boxof'] = boxof;
    data['hsn_sku'] = hsnSku;
    data['po_no'] = poNo;
    data['expiraton_date'] = expiratonDate;
    data['ship_to'] = shipTo;
    data['ship_date'] = shipDate;
    data['vendor_item_no'] = vendorItemNo;
    data['short_qty_code'] = shortQtyCode;
    data['country_id'] = countryId;
    data['carton'] = carton;
    data['SSCCBarcodeNumber'] = sSCCBarcodeNumber;
    data['SSCCBarcodeNumber_without_check'] = sSCCBarcodeNumberWithoutCheck;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['gcpGLNID'] = gcpGLNID;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
