// ignore_for_file: file_names

class GtinProductDetailsModel {
  bool? productDataAvailable;
  Data? data;

  GtinProductDetailsModel({this.productDataAvailable, this.data});

  GtinProductDetailsModel.fromJson(Map<String, dynamic> json) {
    productDataAvailable = json['ProductDataAvailable'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductDataAvailable'] = productDataAvailable;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? gtin;
  String? companyName;
  String? gpcCategoryCode;
  BrandName? brandName;
  BrandName? productDescription;
  BrandName? productImageUrl;
  String? unitCode;
  String? unitValue;
  String? countryOfSaleCode;
  String? productName;
  String? gcpGLNID;
  String? status;
  String? licenceKey;
  String? licenceType;
  String? moName;
  String? type;
  String? countryOfSaleName;
  String? contactWebsite;
  String? formattedAddress;

  Data({
    this.gtin,
    this.companyName,
    this.gpcCategoryCode,
    this.brandName,
    this.productDescription,
    this.productImageUrl,
    this.unitCode,
    this.unitValue,
    this.countryOfSaleCode,
    this.productName,
    this.gcpGLNID,
    this.status,
    this.licenceKey,
    this.licenceType,
    this.moName,
    this.type,
    this.countryOfSaleName,
    this.contactWebsite,
    this.formattedAddress,
  });

  Data.fromJson(Map<String, dynamic> json) {
    gtin = json['gtin'];
    companyName = json['companyName'];
    gpcCategoryCode = json['gpcCategoryCode'];
    brandName = json['brandName'] != null
        ? BrandName.fromJson(json['brandName'])
        : null;
    productDescription = json['productDescription'] != null
        ? BrandName.fromJson(json['productDescription'])
        : null;
    productImageUrl = json['productImageUrl'] != null
        ? BrandName.fromJson(json['productImageUrl'])
        : null;
    unitCode = json['unitCode'];
    unitValue = json['unitValue'];
    countryOfSaleCode = json['countryOfSaleCode'];
    productName = json['productName'];
    gcpGLNID = json['gcpGLNID'];
    status = json['status'];
    licenceKey = json['licenceKey'];
    licenceType = json['licenceType'];
    moName = json['moName'];
    type = json['type'];
    countryOfSaleName = json['countryOfSaleName'];
    contactWebsite = json['contactWebsite'];
    formattedAddress = json['formattedAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gtin'] = gtin;
    data['companyName'] = companyName;
    data['gpcCategoryCode'] = gpcCategoryCode;
    if (brandName != null) {
      data['brandName'] = brandName!.toJson();
    }
    if (productDescription != null) {
      data['productDescription'] = productDescription!.toJson();
    }
    if (productImageUrl != null) {
      data['productImageUrl'] = productImageUrl!.toJson();
    }
    data['unitCode'] = unitCode;
    data['unitValue'] = unitValue;
    data['countryOfSaleCode'] = countryOfSaleCode;
    data['productName'] = productName;
    data['gcpGLNID'] = gcpGLNID;
    data['status'] = status;
    data['licenceKey'] = licenceKey;
    data['licenceType'] = licenceType;
    data['moName'] = moName;
    data['type'] = type;
    data['countryOfSaleName'] = countryOfSaleName;
    data['contactWebsite'] = contactWebsite;
    data['formattedAddress'] = formattedAddress;
    return data;
  }
}

class BrandName {
  String? language;
  String? value;

  BrandName({this.language, this.value});

  BrandName.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    data['value'] = value;
    return data;
  }
}
