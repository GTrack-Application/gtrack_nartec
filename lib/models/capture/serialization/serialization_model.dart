class SerializationModel {
  String? gTIN;
  String? serialNo;
  String? eXPIRYDATE;
  String? bATCH;
  String? mANUFACTURINGDATE;

  SerializationModel(
      {this.gTIN,
        this.serialNo,
        this.eXPIRYDATE,
        this.bATCH,
        this.mANUFACTURINGDATE});

  SerializationModel.fromJson(Map<String, dynamic> json) {
    gTIN = json['GTIN'];
    serialNo = json['SerialNo'];
    eXPIRYDATE = json['EXPIRY_DATE'];
    bATCH = json['BATCH'];
    mANUFACTURINGDATE = json['MANUFACTURING_DATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GTIN'] = this.gTIN;
    data['SerialNo'] = this.serialNo;
    data['EXPIRY_DATE'] = this.eXPIRYDATE;
    data['BATCH'] = this.bATCH;
    data['MANUFACTURING_DATE'] = this.mANUFACTURINGDATE;
    return data;
  }
}
