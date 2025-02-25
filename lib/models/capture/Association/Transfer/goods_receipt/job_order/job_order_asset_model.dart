class JobOrderAssetModel {
  final int tblAssetMasterEncodeAssetCaptureID;
  final String majorCategory;
  final String majorCategoryDescription;
  final String minorCategory;
  final String minorCategoryDescription;
  final String tagNumber;
  final String serialNumber;
  final String assetDescription;
  final String assetType;
  final String assetCondition;
  final String country;
  final String region;
  final String cityName;
  final String dao;
  final String daoName;
  final String businessUnit;
  final String? buildingNo;
  final String floorNo;
  final String employeeId;
  final String? poNumber;
  final String? poDate;
  final String? deliveryNoteNo;
  final String? supplier;
  final String? invoiceNo;
  final String? invoiceDate;
  final String? modelOfAsset;
  final String manufacturer;
  final String? ownership;
  final String bought;
  final String terminalId;
  final String atmNumber;
  final String locationTag;
  final String? buildingName;
  final String? buildingAddress;
  final String userLoginId;
  final String mainSubSeriesNo;
  final String assetDateCaptured;
  final String assetTimeCaptured;
  final String assetDateScanned;
  final String assetTimeScanned;
  final String qty;
  final String phoneExtNo;
  final String fullLocationDetails;
  final String? journalRefNo;
  final String? images;

  JobOrderAssetModel({
    required this.tblAssetMasterEncodeAssetCaptureID,
    required this.majorCategory,
    required this.majorCategoryDescription,
    required this.minorCategory,
    required this.minorCategoryDescription,
    required this.tagNumber,
    required this.serialNumber,
    required this.assetDescription,
    required this.assetType,
    required this.assetCondition,
    required this.country,
    required this.region,
    required this.cityName,
    required this.dao,
    required this.daoName,
    required this.businessUnit,
    this.buildingNo,
    required this.floorNo,
    required this.employeeId,
    this.poNumber,
    this.poDate,
    this.deliveryNoteNo,
    this.supplier,
    this.invoiceNo,
    this.invoiceDate,
    this.modelOfAsset,
    required this.manufacturer,
    this.ownership,
    required this.bought,
    required this.terminalId,
    required this.atmNumber,
    required this.locationTag,
    this.buildingName,
    this.buildingAddress,
    required this.userLoginId,
    required this.mainSubSeriesNo,
    required this.assetDateCaptured,
    required this.assetTimeCaptured,
    required this.assetDateScanned,
    required this.assetTimeScanned,
    required this.qty,
    required this.phoneExtNo,
    required this.fullLocationDetails,
    this.journalRefNo,
    this.images,
  });

  factory JobOrderAssetModel.fromJson(Map<String, dynamic> json) {
    return JobOrderAssetModel(
      tblAssetMasterEncodeAssetCaptureID:
          json['TblAssetMasterEncodeAssetCaptureID'] ?? 0,
      majorCategory: json['MajorCategory'] ?? '',
      majorCategoryDescription: json['MajorCategoryDescription'] ?? '',
      minorCategory: json['MInorCategory'] ?? '',
      minorCategoryDescription: json['MinorCategoryDescription'] ?? '',
      tagNumber: json['TagNumber'] ?? '',
      serialNumber: json['sERIALnUMBER'] ?? '',
      assetDescription: json['aSSETdESCRIPTION'] ?? '',
      assetType: json['assettYPE'] ?? '',
      assetCondition: json['aSSETcONDITION'] ?? '',
      country: json['cOUNTRY'] ?? '',
      region: json['rEGION'] ?? '',
      cityName: json['CityName'] ?? '',
      dao: json['Dao'] ?? '',
      daoName: json['DaoName'] ?? '',
      businessUnit: json['BusinessUnit'] ?? '',
      buildingNo: json['BUILDINGNO'],
      floorNo: json['FLOORNO'] ?? '',
      employeeId: json['EMPLOYEEID'] ?? '',
      poNumber: json['ponUmber'],
      poDate: json['Podate'],
      deliveryNoteNo: json['DeliveryNoteNo'],
      supplier: json['Supplier'],
      invoiceNo: json['InvoiceNo'],
      invoiceDate: json['InvoiceDate'],
      modelOfAsset: json['ModelofAsset'],
      manufacturer: json['Manufacturer'] ?? '',
      ownership: json['Ownership'],
      bought: json['Bought'] ?? '',
      terminalId: json['TerminalID'] ?? '',
      atmNumber: json['ATMNumber'] ?? '',
      locationTag: json['LocationTag'] ?? '',
      buildingName: json['buildingName'],
      buildingAddress: json['buildingAddress'],
      userLoginId: json['UserLoginID'] ?? '',
      mainSubSeriesNo: json['MainSubSeriesNo'] ?? '',
      assetDateCaptured: json['assetdatecaptured'] ?? '',
      assetTimeCaptured: json['assetTimeCaptured'] ?? '',
      assetDateScanned: json['assetdatescanned'] ?? '',
      assetTimeScanned: json['assettimeScanned'] ?? '',
      qty: json['QTY'] ?? '',
      phoneExtNo: json['PhoneExtNo'] ?? '',
      fullLocationDetails: json['FullLocationDetails'] ?? '',
      journalRefNo: json['JournalRefNo'],
      images: json['Images'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TblAssetMasterEncodeAssetCaptureID': tblAssetMasterEncodeAssetCaptureID,
      'MajorCategory': majorCategory,
      'MajorCategoryDescription': majorCategoryDescription,
      'MInorCategory': minorCategory,
      'MinorCategoryDescription': minorCategoryDescription,
      'TagNumber': tagNumber,
      'sERIALnUMBER': serialNumber,
      'aSSETdESCRIPTION': assetDescription,
      'assettYPE': assetType,
      'aSSETcONDITION': assetCondition,
      'cOUNTRY': country,
      'rEGION': region,
      'CityName': cityName,
      'Dao': dao,
      'DaoName': daoName,
      'BusinessUnit': businessUnit,
      'BUILDINGNO': buildingNo,
      'FLOORNO': floorNo,
      'EMPLOYEEID': employeeId,
      'ponUmber': poNumber,
      'Podate': poDate,
      'DeliveryNoteNo': deliveryNoteNo,
      'Supplier': supplier,
      'InvoiceNo': invoiceNo,
      'InvoiceDate': invoiceDate,
      'ModelofAsset': modelOfAsset,
      'Manufacturer': manufacturer,
      'Ownership': ownership,
      'Bought': bought,
      'TerminalID': terminalId,
      'ATMNumber': atmNumber,
      'LocationTag': locationTag,
      'buildingName': buildingName,
      'buildingAddress': buildingAddress,
      'UserLoginID': userLoginId,
      'MainSubSeriesNo': mainSubSeriesNo,
      'assetdatecaptured': assetDateCaptured,
      'assetTimeCaptured': assetTimeCaptured,
      'assetdatescanned': assetDateScanned,
      'assettimeScanned': assetTimeScanned,
      'QTY': qty,
      'PhoneExtNo': phoneExtNo,
      'FullLocationDetails': fullLocationDetails,
      'JournalRefNo': journalRefNo,
      'Images': images,
    };
  }
}
