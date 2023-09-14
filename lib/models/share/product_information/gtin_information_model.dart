class GtinInformationModel {
  int? status;
  GtinArr? gtinArr;
  List<ProductContents>? productContents;

  GtinInformationModel({this.status, this.gtinArr, this.productContents});

  GtinInformationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    gtinArr =
        json['gtinArr'] != null ? GtinArr.fromJson(json['gtinArr']) : null;
    if (json['productContents'] != null) {
      productContents = <ProductContents>[];
      json['productContents'].forEach((v) {
        productContents!.add(ProductContents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (gtinArr != null) {
      data['gtinArr'] = gtinArr!.toJson();
    }
    if (productContents != null) {
      data['productContents'] =
          productContents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GtinArr {
  String? gtin;
  String? companyName;
  String? licenceKey;
  String? website;
  String? address;
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

  GtinArr(
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

  GtinArr.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gtin'] = gtin;
    data['companyName'] = companyName;
    data['licenceKey'] = licenceKey;
    data['website'] = website;
    data['address'] = address;
    data['licenceType'] = licenceType;
    data['gpcCategoryCode'] = gpcCategoryCode;
    data['brandName'] = brandName;
    data['productDescription'] = productDescription;
    data['productImageUrl'] = productImageUrl;
    data['unitCode'] = unitCode;
    data['unitValue'] = unitValue;
    data['countryOfSaleCode'] = countryOfSaleCode;
    data['productName'] = productName;
    data['gcpGLNID'] = gcpGLNID;
    data['status'] = status;
    return data;
  }
}

class ProductContents {
  String? iD;
  String? productAllergenInformation;
  String? productNutrientsInformation;
  String? gTIN;
  String? linkType;
  String? batch;
  String? expiry;
  String? serial;
  String? manufacturingDate;
  String? bestBeforeDate;
  String? gLNIDFrom;
  String? unitPrice;
  String? ingredients;
  String? allergenInfo;
  String? calories;
  String? sugar;
  String? salt;
  String? fat;

  ProductContents(
      {this.iD,
      this.productAllergenInformation,
      this.productNutrientsInformation,
      this.gTIN,
      this.linkType,
      this.batch,
      this.expiry,
      this.serial,
      this.manufacturingDate,
      this.bestBeforeDate,
      this.gLNIDFrom,
      this.unitPrice,
      this.ingredients,
      this.allergenInfo,
      this.calories,
      this.sugar,
      this.salt,
      this.fat});

  ProductContents.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productAllergenInformation = json['ProductAllergenInformation'];
    productNutrientsInformation = json['ProductNutrientsInformation'];
    gTIN = json['GTIN'];
    linkType = json['LinkType'];
    batch = json['Batch'];
    expiry = json['Expiry'];
    serial = json['Serial'];
    manufacturingDate = json['ManufacturingDate'];
    bestBeforeDate = json['bestBeforeDate'];
    gLNIDFrom = json['GLNIDFrom'];
    unitPrice = json['unitPrice'];
    ingredients = json['ingredients'];
    allergenInfo = json['allergen_info'];
    calories = json['calories'];
    sugar = json['sugar'];
    salt = json['salt'];
    fat = json['fat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['ProductAllergenInformation'] = productAllergenInformation;
    data['ProductNutrientsInformation'] = productNutrientsInformation;
    data['GTIN'] = gTIN;
    data['LinkType'] = linkType;
    data['Batch'] = batch;
    data['Expiry'] = expiry;
    data['Serial'] = serial;
    data['ManufacturingDate'] = manufacturingDate;
    data['bestBeforeDate'] = bestBeforeDate;
    data['GLNIDFrom'] = gLNIDFrom;
    data['unitPrice'] = unitPrice;
    data['ingredients'] = ingredients;
    data['allergen_info'] = allergenInfo;
    data['calories'] = calories;
    data['sugar'] = sugar;
    data['salt'] = salt;
    data['fat'] = fat;
    return data;
  }
}
