class EventsScreenModel {
  String? tblTrxHeaderSessionID;
  String? trxTypeId;
  String? memberID;
  String? trxRefNo;
  String? trxRefDescription;
  String? trxEventId;
  String? trxDateCreated;
  String? trxDateLastUpdate;
  String? trxGLNCodeDocId;
  String? trxGLNIDFrom;
  String? trxGLNIDTo;
  String? itemRefNo;
  String? itemRefLinkInfo;
  String? itemGPSOnGoLat;
  String? itemGPSOnGoLon;
  String? batch;
  String? expiry;
  String? manufacturingDate;
  String? serial;
  String? quantity;

  EventsScreenModel(
      {this.tblTrxHeaderSessionID,
      this.trxTypeId,
      this.memberID,
      this.trxRefNo,
      this.trxRefDescription,
      this.trxEventId,
      this.trxDateCreated,
      this.trxDateLastUpdate,
      this.trxGLNCodeDocId,
      this.trxGLNIDFrom,
      this.trxGLNIDTo,
      this.itemRefNo,
      this.itemRefLinkInfo,
      this.itemGPSOnGoLat,
      this.itemGPSOnGoLon,
      this.batch,
      this.expiry,
      this.manufacturingDate,
      this.serial,
      this.quantity});

  EventsScreenModel.fromJson(Map<String, dynamic> json) {
    tblTrxHeaderSessionID = json['tblTrxHeaderSessionID'];
    trxTypeId = json['TrxTypeId'];
    memberID = json['MemberID'];
    trxRefNo = json['TrxRefNo'];
    trxRefDescription = json['TrxRefDescription'];
    trxEventId = json['TrxEventId'];
    trxDateCreated = json['TrxDateCreated'];
    trxDateLastUpdate = json['TrxDateLastUpdate'];
    trxGLNCodeDocId = json['TrxGLNCodeDocId'];
    trxGLNIDFrom = json['TrxGLNIDFrom'];
    trxGLNIDTo = json['TrxGLNIDTo'];
    itemRefNo = json['ItemRefNo'];
    itemRefLinkInfo = json['ItemRefLinkInfo'];
    itemGPSOnGoLat = json['ItemGPSOnGoLat'];
    itemGPSOnGoLon = json['ItemGPSOnGoLon'];
    batch = json['Batch'];
    expiry = json['Expiry'];
    manufacturingDate = json['ManufacturingDate'];
    serial = json['Serial'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tblTrxHeaderSessionID'] = tblTrxHeaderSessionID;
    data['TrxTypeId'] = trxTypeId;
    data['MemberID'] = memberID;
    data['TrxRefNo'] = trxRefNo;
    data['TrxRefDescription'] = trxRefDescription;
    data['TrxEventId'] = trxEventId;
    data['TrxDateCreated'] = trxDateCreated;
    data['TrxDateLastUpdate'] = trxDateLastUpdate;
    data['TrxGLNCodeDocId'] = trxGLNCodeDocId;
    data['TrxGLNIDFrom'] = trxGLNIDFrom;
    data['TrxGLNIDTo'] = trxGLNIDTo;
    data['ItemRefNo'] = itemRefNo;
    data['ItemRefLinkInfo'] = itemRefLinkInfo;
    data['ItemGPSOnGoLat'] = itemGPSOnGoLat;
    data['ItemGPSOnGoLon'] = itemGPSOnGoLon;
    data['Batch'] = batch;
    data['Expiry'] = expiry;
    data['ManufacturingDate'] = manufacturingDate;
    data['Serial'] = serial;
    data['Quantity'] = quantity;
    return data;
  }
}
