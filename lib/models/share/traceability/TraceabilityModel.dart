// ignore_for_file: file_names

class TraceabilityModel {
  int? id;
  String? gs1UserId;
  String? transactionType;
  String? gTIN;
  String? gLNFrom;
  String? gLNTo;
  String? industryType;
  GLNFromDetails? gLNFromDetails;
  GLNFromDetails? gLNToDetails;

  TraceabilityModel({
    this.id,
    this.gs1UserId,
    this.transactionType,
    this.gTIN,
    this.gLNFrom,
    this.gLNTo,
    this.industryType,
    this.gLNFromDetails,
    this.gLNToDetails,
  });

  TraceabilityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gs1UserId = json['gs1UserId'];
    transactionType = json['TransactionType'];
    gTIN = json['GTIN'];
    gLNFrom = json['GLNFrom'];
    gLNTo = json['GLNTo'];
    industryType = json['IndustryType'];
    gLNFromDetails = json['GLNFromDetails'] != null
        ? GLNFromDetails.fromJson(json['GLNFromDetails'])
        : null;
    gLNToDetails = json['GLNToDetails'] != null
        ? GLNFromDetails.fromJson(json['GLNToDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['gs1UserId'] = gs1UserId;
    data['TransactionType'] = transactionType;
    data['GTIN'] = gTIN;
    data['GLNFrom'] = gLNFrom;
    data['GLNTo'] = gLNTo;
    data['IndustryType'] = industryType;
    if (gLNFromDetails != null) {
      data['GLNFromDetails'] = gLNFromDetails!.toJson();
    }
    if (gLNToDetails != null) {
      data['GLNToDetails'] = gLNToDetails!.toJson();
    }
    return data;
  }
}

class GLNFromDetails {
  String? locationNameEn;
  String? locationNameAr;
  String? addressEn;
  String? addressAr;
  String? longitude;
  String? latitude;

  GLNFromDetails({
    this.locationNameEn,
    this.locationNameAr,
    this.addressEn,
    this.addressAr,
    this.longitude,
    this.latitude,
  });

  GLNFromDetails.fromJson(Map<String, dynamic> json) {
    locationNameEn = json['locationNameEn'];
    locationNameAr = json['locationNameAr'];
    addressEn = json['AddressEn'];
    addressAr = json['AddressAr'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationNameEn'] = locationNameEn;
    data['locationNameAr'] = locationNameAr;
    data['AddressEn'] = addressEn;
    data['AddressAr'] = addressAr;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}
