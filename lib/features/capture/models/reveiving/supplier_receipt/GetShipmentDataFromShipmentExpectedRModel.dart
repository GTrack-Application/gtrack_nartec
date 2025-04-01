// ignore_for_file: file_names

class GetShipmentDataFromShipmentExpectedRModel {
  String? sHIPMENTID;
  String? cONTAINERID;
  String? aRRIVALWAREHOUSE;
  String? iTEMNAME;
  String? iTEMID;
  String? pURCHID;
  String? cLASSIFICATION;
  String? sERIALNUM;
  String? rCVDCONFIGID;
  String? rCVDDATE;
  String? gTIN;
  String? rZONE;
  String? pALLETDATE;
  String? pALLETCODE;
  String? bIN;
  String? rEMARKS;
  num? pOQTY;
  num? rCVQTY;
  num? rEMAININGQTY;
  String? uSERID;
  String? tRXDATETIME;
  num? wIDTH;
  num? hEIGHT;
  num? lENGTH;
  num? wEIGHT;

  GetShipmentDataFromShipmentExpectedRModel(
      {this.sHIPMENTID,
      this.cONTAINERID,
      this.aRRIVALWAREHOUSE,
      this.iTEMNAME,
      this.iTEMID,
      this.pURCHID,
      this.cLASSIFICATION,
      this.sERIALNUM,
      this.rCVDCONFIGID,
      this.rCVDDATE,
      this.gTIN,
      this.rZONE,
      this.pALLETDATE,
      this.pALLETCODE,
      this.bIN,
      this.rEMARKS,
      this.pOQTY,
      this.rCVQTY,
      this.rEMAININGQTY,
      this.uSERID,
      this.tRXDATETIME,
      this.wIDTH,
      this.hEIGHT,
      this.lENGTH,
      this.wEIGHT});

  GetShipmentDataFromShipmentExpectedRModel.fromJson(
      Map<String, dynamic> json) {
    sHIPMENTID = json['SHIPMENTID'];
    cONTAINERID = json['CONTAINERID'];
    aRRIVALWAREHOUSE = json['ARRIVALWAREHOUSE'];
    iTEMNAME = json['ITEMNAME'];
    iTEMID = json['ITEMID'];
    pURCHID = json['PURCHID'];
    cLASSIFICATION = json['CLASSIFICATION'];
    sERIALNUM = json['SERIALNUM'];
    rCVDCONFIGID = json['RCVDCONFIGID'];
    rCVDDATE = json['RCVD_DATE'];
    gTIN = json['GTIN'];
    rZONE = json['RZONE'];
    pALLETDATE = json['PALLET_DATE'];
    pALLETCODE = json['PALLETCODE'];
    bIN = json['BIN'];
    rEMARKS = json['REMARKS'];
    pOQTY = json['POQTY'];
    rCVQTY = json['RCVQTY'];
    rEMAININGQTY = json['REMAININGQTY'];
    uSERID = json['USERID'];
    tRXDATETIME = json['TRXDATETIME'];
    wIDTH = json['WIDTH'];
    hEIGHT = json['HEIGHT'];
    lENGTH = json['LENGTH'];
    wEIGHT = json['WEIGHT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SHIPMENTID'] = sHIPMENTID;
    data['CONTAINERID'] = cONTAINERID;
    data['ARRIVALWAREHOUSE'] = aRRIVALWAREHOUSE;
    data['ITEMNAME'] = iTEMNAME;
    data['ITEMID'] = iTEMID;
    data['PURCHID'] = pURCHID;
    data['CLASSIFICATION'] = cLASSIFICATION;
    data['SERIALNUM'] = sERIALNUM;
    data['RCVDCONFIGID'] = rCVDCONFIGID;
    data['RCVD_DATE'] = rCVDDATE;
    data['GTIN'] = gTIN;
    data['RZONE'] = rZONE;
    data['PALLET_DATE'] = pALLETDATE;
    data['PALLETCODE'] = pALLETCODE;
    data['BIN'] = bIN;
    data['REMARKS'] = rEMARKS;
    data['POQTY'] = pOQTY;
    data['RCVQTY'] = rCVQTY;
    data['REMAININGQTY'] = rEMAININGQTY;
    data['USERID'] = uSERID;
    data['TRXDATETIME'] = tRXDATETIME;
    data['WIDTH'] = wIDTH;
    data['HEIGHT'] = hEIGHT;
    data['LENGTH'] = lENGTH;
    data['WEIGHT'] = wEIGHT;
    return data;
  }
}
