class GtinInformationModel {
  String? gtin;
  String? companyName;
  String? licenceKey;
  String? website;
  Null? address;
  String? licenceType;
  String? gpcCategoryCode;
  String? brandName;
  String? productDescription;
  String? productImageUrl;
  String? unitCode;
  String? unitValue;
  String? countryOfSaleCode;
  String? productName;
  String? gcpGLNID;
  String? status;

  GtinInformationModel(
      {this.gtin,
      this.companyName,
      this.licenceKey,
      this.website,
      this.address,
      this.licenceType,
      this.gpcCategoryCode,
      this.brandName,
      this.productDescription,
      this.productImageUrl,
      this.unitCode,
      this.unitValue,
      this.countryOfSaleCode,
      this.productName,
      this.gcpGLNID,
      this.status});

  GtinInformationModel.fromJson(Map<String, dynamic> json) {
    gtin = json['gtin'];
    companyName = json['companyName'];
    licenceKey = json['licenceKey'];
    website = json['website'];
    address = json['address'];
    licenceType = json['licenceType'];
    gpcCategoryCode = json['gpcCategoryCode'];
    brandName = json['brandName'];
    productDescription = json['productDescription'];
    productImageUrl = json['productImageUrl'];
    unitCode = json['unitCode'];
    unitValue = json['unitValue'];
    countryOfSaleCode = json['countryOfSaleCode'];
    productName = json['productName'];
    gcpGLNID = json['gcpGLNID'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gtin'] = this.gtin;
    data['companyName'] = this.companyName;
    data['licenceKey'] = this.licenceKey;
    data['website'] = this.website;
    data['address'] = this.address;
    data['licenceType'] = this.licenceType;
    data['gpcCategoryCode'] = this.gpcCategoryCode;
    data['brandName'] = this.brandName;
    data['productDescription'] = this.productDescription;
    data['productImageUrl'] = this.productImageUrl;
    data['unitCode'] = this.unitCode;
    data['unitValue'] = this.unitValue;
    data['countryOfSaleCode'] = this.countryOfSaleCode;
    data['productName'] = this.productName;
    data['gcpGLNID'] = this.gcpGLNID;
    data['status'] = this.status;
    return data;
  }
}
