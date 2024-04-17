class GtinInformationModel {
  bool? productDataAvailable;
  CompanyInfo? companyInfo;

  GtinInformationModel({this.productDataAvailable, this.companyInfo});

  GtinInformationModel.fromJson(Map<String, dynamic> json) {
    productDataAvailable = json['ProductDataAvailable'];
    companyInfo = json['companyInfo'] != null
        ? CompanyInfo.fromJson(json['companyInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductDataAvailable'] = productDataAvailable;
    if (companyInfo != null) {
      data['companyInfo'] = companyInfo!.toJson();
    }
    return data;
  }
}

class CompanyInfo {
  String? companyName;
  String? licenceKey;
  String? licenceType;
  String? licenceStatus;
  String? licensingMOName;
  String? licensingMOGLN;
  String? primaryMOName;
  String? primaryMOGLN;
  String? contactWebsite;
  String? formattedAddress;
  String? dateCreated;
  String? dateUpdated;
  String? gtin;

  CompanyInfo(
      {this.companyName,
      this.licenceKey,
      this.licenceType,
      this.licenceStatus,
      this.licensingMOName,
      this.licensingMOGLN,
      this.primaryMOName,
      this.primaryMOGLN,
      this.contactWebsite,
      this.formattedAddress,
      this.dateCreated,
      this.dateUpdated,
      this.gtin});

  CompanyInfo.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    licenceKey = json['licenceKey'];
    licenceType = json['licenceType'];
    licenceStatus = json['licenceStatus'];
    licensingMOName = json['licensingMOName'];
    licensingMOGLN = json['licensingMOGLN'];
    primaryMOName = json['primaryMOName'];
    primaryMOGLN = json['primaryMOGLN'];
    contactWebsite = json['contactWebsite'];
    formattedAddress = json['formattedAddress'];
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
    gtin = json['gtin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    data['licenceKey'] = licenceKey;
    data['licenceType'] = licenceType;
    data['licenceStatus'] = licenceStatus;
    data['licensingMOName'] = licensingMOName;
    data['licensingMOGLN'] = licensingMOGLN;
    data['primaryMOName'] = primaryMOName;
    data['primaryMOGLN'] = primaryMOGLN;
    data['contactWebsite'] = contactWebsite;
    data['formattedAddress'] = formattedAddress;
    data['dateCreated'] = dateCreated;
    data['dateUpdated'] = dateUpdated;
    data['gtin'] = gtin;
    return data;
  }
}

class GtinInformationDataModel {
  bool? productDataAvailable;
  Data? data;

  GtinInformationDataModel({this.productDataAvailable, this.data});

  GtinInformationDataModel.fromJson(Map<String, dynamic> json) {
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
  String? gpcCategoryName;
  BrandName? brandName;
  BrandName? productDescription;
  BrandName? productImageUrl;
  String? unitCode;
  String? unitValue;
  String? productName;
  String? moName;
  String? licenceKey;
  String? licenceType;
  String? type;
  String? countryOfSaleName;
  String? gcpGLNID;
  String? contactWebsite;
  String? formattedAddress;

  Data(
      {this.gtin,
      this.companyName,
      this.gpcCategoryCode,
      this.gpcCategoryName,
      this.brandName,
      this.productDescription,
      this.productImageUrl,
      this.unitCode,
      this.unitValue,
      this.productName,
      this.moName,
      this.licenceKey,
      this.licenceType,
      this.type,
      this.countryOfSaleName,
      this.gcpGLNID,
      this.contactWebsite,
      this.formattedAddress});

  Data.fromJson(Map<String, dynamic> json) {
    gtin = json['gtin'];
    companyName = json['companyName'];
    gpcCategoryCode = json['gpcCategoryCode'];
    gpcCategoryName = json['gpcCategoryName'];
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
    productName = json['productName'];
    moName = json['moName'];
    licenceKey = json['licenceKey'];
    licenceType = json['licenceType'];
    type = json['type'];
    countryOfSaleName = json['countryOfSaleName'];
    gcpGLNID = json['gcpGLNID'];
    contactWebsite = json['contactWebsite'];
    formattedAddress = json['formattedAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gtin'] = gtin;
    data['companyName'] = companyName;
    data['gpcCategoryCode'] = gpcCategoryCode;
    data['gpcCategoryName'] = gpcCategoryName;
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
    data['productName'] = productName;
    data['moName'] = moName;
    data['licenceKey'] = licenceKey;
    data['licenceType'] = licenceType;
    data['type'] = type;
    data['countryOfSaleName'] = countryOfSaleName;
    data['gcpGLNID'] = gcpGLNID;
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
