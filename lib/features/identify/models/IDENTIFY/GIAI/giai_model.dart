class GIAIModel {
  String? id;
  String? memberId;
  String? majorCategory;
  String? majorCategoryDescription;
  String? minorCategory;
  String? minorCategoryDescription;
  String? serialNumber;
  String? assetDescription;
  String? assetType;
  String? assetCondition;
  String? country;
  String? region;
  String? cityName;
  String? dao;
  String? daoName;
  String? businessUnit;
  String? buildingNo;
  String? floorNo;
  String? employeeID;
  String? pONumber;
  String? pODate;
  String? deliveryNoteNo;
  String? supplier;
  String? invoiceNo;
  String? invoiceDate;
  String? modelOfAsset;
  String? manufacturer;
  String? ownership;
  String? bought;
  String? terminalID;
  String? aTMNumber;
  String? locationTag;
  String? buildingName;
  String? buildingAddress;
  String? userLoginID;
  String? mainSubSeriesNo;
  String? assetDateCaptured;
  String? assetTimeCaptured;
  String? assetDateScanned;
  String? assetTimeScanned;
  String? quantity;
  String? phoneExtNo;
  String? fullLocationDetails;
  String? tagNumber;
  String? createdAt;
  String? updatedAt;

  GIAIModel({
    this.id,
    this.memberId,
    this.majorCategory,
    this.majorCategoryDescription,
    this.minorCategory,
    this.minorCategoryDescription,
    this.serialNumber,
    this.assetDescription,
    this.assetType,
    this.assetCondition,
    this.country,
    this.region,
    this.cityName,
    this.dao,
    this.daoName,
    this.businessUnit,
    this.buildingNo,
    this.floorNo,
    this.employeeID,
    this.pONumber,
    this.pODate,
    this.deliveryNoteNo,
    this.supplier,
    this.invoiceNo,
    this.invoiceDate,
    this.modelOfAsset,
    this.manufacturer,
    this.ownership,
    this.bought,
    this.terminalID,
    this.aTMNumber,
    this.locationTag,
    this.buildingName,
    this.buildingAddress,
    this.userLoginID,
    this.mainSubSeriesNo,
    this.assetDateCaptured,
    this.assetTimeCaptured,
    this.assetDateScanned,
    this.assetTimeScanned,
    this.quantity,
    this.phoneExtNo,
    this.fullLocationDetails,
    this.tagNumber,
    this.createdAt,
    this.updatedAt,
  });

  GIAIModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    majorCategory = json['MajorCategory'];
    majorCategoryDescription = json['MajorCategoryDescription'];
    minorCategory = json['MinorCategory'];
    minorCategoryDescription = json['MinorCategoryDescription'];
    serialNumber = json['SerialNumber'];
    assetDescription = json['AssetDescription'];
    assetType = json['AssetType'];
    assetCondition = json['AssetCondition'];
    country = json['Country'];
    region = json['Region'];
    cityName = json['CityName'];
    dao = json['Dao'];
    daoName = json['DaoName'];
    businessUnit = json['BusinessUnit'];
    buildingNo = json['BuildingNo'];
    floorNo = json['FloorNo'];
    employeeID = json['EmployeeID'];
    pONumber = json['PONumber'];
    pODate = json['PODate'];
    deliveryNoteNo = json['DeliveryNoteNo'];
    supplier = json['Supplier'];
    invoiceNo = json['InvoiceNo'];
    invoiceDate = json['InvoiceDate'];
    modelOfAsset = json['ModelOfAsset'];
    manufacturer = json['Manufacturer'];
    ownership = json['Ownership'];
    bought = json['Bought'];
    terminalID = json['TerminalID'];
    aTMNumber = json['ATMNumber'];
    locationTag = json['LocationTag'];
    buildingName = json['BuildingName'];
    buildingAddress = json['BuildingAddress'];
    userLoginID = json['UserLoginID'];
    mainSubSeriesNo = json['MainSubSeriesNo'];
    assetDateCaptured = json['AssetDateCaptured'];
    assetTimeCaptured = json['AssetTimeCaptured'];
    assetDateScanned = json['AssetDateScanned'];
    assetTimeScanned = json['AssetTimeScanned'];
    quantity = json['Quantity'];
    phoneExtNo = json['PhoneExtNo'];
    fullLocationDetails = json['FullLocationDetails'];
    tagNumber = json['TagNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['memberId'] = memberId;
    data['MajorCategory'] = majorCategory;
    data['MajorCategoryDescription'] = majorCategoryDescription;
    data['MinorCategory'] = minorCategory;
    data['MinorCategoryDescription'] = minorCategoryDescription;
    data['SerialNumber'] = serialNumber;
    data['AssetDescription'] = assetDescription;
    data['AssetType'] = assetType;
    data['AssetCondition'] = assetCondition;
    data['Country'] = country;
    data['Region'] = region;
    data['CityName'] = cityName;
    data['Dao'] = dao;
    data['DaoName'] = daoName;
    data['BusinessUnit'] = businessUnit;
    data['BuildingNo'] = buildingNo;
    data['FloorNo'] = floorNo;
    data['EmployeeID'] = employeeID;
    data['PONumber'] = pONumber;
    data['PODate'] = pODate;
    data['DeliveryNoteNo'] = deliveryNoteNo;
    data['Supplier'] = supplier;
    data['InvoiceNo'] = invoiceNo;
    data['InvoiceDate'] = invoiceDate;
    data['ModelOfAsset'] = modelOfAsset;
    data['Manufacturer'] = manufacturer;
    data['Ownership'] = ownership;
    data['Bought'] = bought;
    data['TerminalID'] = terminalID;
    data['ATMNumber'] = aTMNumber;
    data['LocationTag'] = locationTag;
    data['BuildingName'] = buildingName;
    data['BuildingAddress'] = buildingAddress;
    data['UserLoginID'] = userLoginID;
    data['MainSubSeriesNo'] = mainSubSeriesNo;
    data['AssetDateCaptured'] = assetDateCaptured;
    data['AssetTimeCaptured'] = assetTimeCaptured;
    data['AssetDateScanned'] = assetDateScanned;
    data['AssetTimeScanned'] = assetTimeScanned;
    data['Quantity'] = quantity;
    data['PhoneExtNo'] = phoneExtNo;
    data['FullLocationDetails'] = fullLocationDetails;
    data['TagNumber'] = tagNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
