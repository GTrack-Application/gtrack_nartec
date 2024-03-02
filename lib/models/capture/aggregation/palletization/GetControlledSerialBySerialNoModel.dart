// ignore_for_file: file_names

class GetControlledSerialBySerialNoModel {
  String? gTIN;
  String? serialNo;
  String? eXPIRYDATE;
  String? bATCH;
  String? mANUFACTURINGDATE;

  GetControlledSerialBySerialNoModel(
      {this.gTIN,
      this.serialNo,
      this.eXPIRYDATE,
      this.bATCH,
      this.mANUFACTURINGDATE});

  GetControlledSerialBySerialNoModel.fromJson(Map<String, dynamic> json) {
    gTIN = json['GTIN'];
    serialNo = json['SerialNo'];
    eXPIRYDATE = json['EXPIRY_DATE'];
    bATCH = json['BATCH'];
    mANUFACTURINGDATE = json['MANUFACTURING_DATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GTIN'] = gTIN;
    data['SerialNo'] = serialNo;
    data['EXPIRY_DATE'] = eXPIRYDATE;
    data['BATCH'] = bATCH;
    data['MANUFACTURING_DATE'] = mANUFACTURINGDATE;
    return data;
  }
}
