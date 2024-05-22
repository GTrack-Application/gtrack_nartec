class SerializationModel {
  List<Data>? data;

  SerializationModel({this.data});

  SerializationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? gTIN;
  String? serialNo;
  String? eXPIRYDATE;
  String? bATCH;
  String? mANUFACTURINGDATE;

  Data(
      {this.gTIN,
      this.serialNo,
      this.eXPIRYDATE,
      this.bATCH,
      this.mANUFACTURINGDATE});

  Data.fromJson(Map<String, dynamic> json) {
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
