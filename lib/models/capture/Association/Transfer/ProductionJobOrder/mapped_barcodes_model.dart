class MappedBarcodesResponse {
  String? message;
  List<MappedBarcode>? data;
  Pagination? pagination;

  MappedBarcodesResponse({this.message, this.data, this.pagination});

  MappedBarcodesResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <MappedBarcode>[];
      json['data'].forEach((v) {
        data!.add(MappedBarcode.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class MappedBarcode {
  String? id;
  String? itemCode;
  String? itemDesc;
  String? gtin;
  String? remarks;
  String? user;
  String? classification;
  String? mainLocation;
  String? binLocation;
  String? intCode;
  String? itemSerialNo;
  String? mapDate;
  String? palletCode;
  String? reference;
  String? sid;
  String? cid;
  String? po;
  String? trans;
  String? length;
  String? width;
  String? height;
  String? weight;
  String? qrCode;
  String? trxDate;
  String? createdAt;
  String? updatedAt;

  MappedBarcode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemCode = json['ItemCode'];
    itemDesc = json['ItemDesc'];
    gtin = json['GTIN'];
    remarks = json['Remarks'];
    user = json['User'];
    classification = json['Classification'];
    mainLocation = json['MainLocation'];
    binLocation = json['BinLocation'];
    intCode = json['IntCode'];
    itemSerialNo = json['ItemSerialNo'];
    mapDate = json['MapDate'];
    palletCode = json['PalletCode'];
    reference = json['Reference'];
    sid = json['SID'];
    cid = json['CID'];
    po = json['PO'];
    trans = json['Trans'];
    length = json['Length'];
    width = json['Width'];
    height = json['Height'];
    weight = json['Weight'];
    qrCode = json['QrCode'];
    trxDate = json['TrxDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class Pagination {
  int? page;
  int? limit;
  int? totalItems;
  int? totalPages;

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
  }
}
