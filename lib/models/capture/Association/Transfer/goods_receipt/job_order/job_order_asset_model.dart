import 'package:flutter/material.dart';

class JobOrderAssetModel {
  final int tblAssetMasterEncodeAssetCaptureID;
  final String? memberId;
  final String? majorCategory;
  final String? majorCategoryDescription;
  final String? minorCategory;
  final String? minorCategoryDescription;
  final String? tagNumber;
  final String? serialNumber;
  final String? assetDescription;
  final String? assetType;
  final String? assetCondition;
  final String? country;
  final String? region;
  final String? cityName;
  final String? dao;
  final String? daoName;
  final String? businessUnit;
  final String? buildingNo;
  final String? floorNo;
  final String? employeeId;
  final String? poNumber;
  final String? poDate;
  final String? deliveryNoteNo;
  final String? supplier;
  final String? invoiceNo;
  final String? invoiceDate;
  final String? modelOfAsset;
  final String? manufacturer;
  final String? ownership;
  final String? bought;
  final String? terminalId;
  final String? atmNumber;
  final String? locationTag;
  final String? buildingName;
  final String? buildingAddress;
  final String? subUserId;
  final String? userLoginId;
  final String? mainSubSeriesNo;
  final String? assetDateCaptured;
  final String? assetTimeCaptured;
  final String? assetDateScanned;
  final String? assetTimeScanned;
  final String? qty;
  final String? phoneExtNo;
  final String? fullLocationDetails;
  final String? journalRefNo;
  final List<AssetImage>? images;
  final TextEditingController? productionLine;

  JobOrderAssetModel({
    required this.tblAssetMasterEncodeAssetCaptureID,
    this.memberId,
    this.majorCategory,
    this.majorCategoryDescription,
    this.minorCategory,
    this.minorCategoryDescription,
    this.tagNumber,
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
    this.employeeId,
    this.poNumber,
    this.poDate,
    this.deliveryNoteNo,
    this.supplier,
    this.invoiceNo,
    this.invoiceDate,
    this.modelOfAsset,
    this.manufacturer,
    this.ownership,
    this.bought,
    this.terminalId,
    this.atmNumber,
    this.locationTag,
    this.buildingName,
    this.buildingAddress,
    this.subUserId,
    this.userLoginId,
    this.mainSubSeriesNo,
    this.assetDateCaptured,
    this.assetTimeCaptured,
    this.assetDateScanned,
    this.assetTimeScanned,
    this.qty,
    this.phoneExtNo,
    this.fullLocationDetails,
    this.journalRefNo,
    this.images,
    this.productionLine,
  });

  factory JobOrderAssetModel.fromJson(Map<String, dynamic> json) {
    List<AssetImage>? imagesList;
    if (json['Images'] != null) {
      if (json['Images'] is List) {
        imagesList = (json['Images'] as List)
            .map((imageJson) => AssetImage.fromJson(imageJson))
            .toList();
      } else if (json['Images'] is String) {
        // For backward compatibility if Images is still coming as string
        imagesList = null;
      }
    }

    return JobOrderAssetModel(
      tblAssetMasterEncodeAssetCaptureID:
          json['TblAssetMasterEncodeAssetCaptureID'] ?? 0,
      memberId: json['memberId'],
      majorCategory: json['MajorCategory'],
      majorCategoryDescription: json['MajorCategoryDescription'],
      minorCategory: json['MInorCategory'],
      minorCategoryDescription: json['MinorCategoryDescription'],
      tagNumber: json['TagNumber'],
      serialNumber: json['sERIALnUMBER'],
      assetDescription: json['aSSETdESCRIPTION'],
      assetType: json['assettYPE'],
      assetCondition: json['aSSETcONDITION'],
      country: json['cOUNTRY'],
      region: json['rEGION'],
      cityName: json['CityName'],
      dao: json['Dao'],
      daoName: json['DaoName'],
      businessUnit: json['BusinessUnit'],
      buildingNo: json['BUILDINGNO'],
      floorNo: json['FLOORNO'],
      employeeId: json['EMPLOYEEID'],
      poNumber: json['ponUmber'],
      poDate: json['Podate'],
      deliveryNoteNo: json['DeliveryNoteNo'],
      supplier: json['Supplier'],
      invoiceNo: json['InvoiceNo'],
      invoiceDate: json['InvoiceDate'],
      modelOfAsset: json['ModelofAsset'],
      manufacturer: json['Manufacturer'],
      ownership: json['Ownership'],
      bought: json['Bought'],
      terminalId: json['TerminalID'],
      atmNumber: json['ATMNumber'],
      locationTag: json['LocationTag'],
      buildingName: json['buildingName'],
      buildingAddress: json['buildingAddress'],
      subUserId: json['subUser_id'],
      userLoginId: json['UserLoginID'],
      mainSubSeriesNo: json['MainSubSeriesNo'],
      assetDateCaptured: json['assetdatecaptured'],
      assetTimeCaptured: json['assetTimeCaptured'],
      assetDateScanned: json['assetdatescanned'],
      assetTimeScanned: json['assettimeScanned'],
      qty: json['QTY'],
      phoneExtNo: json['PhoneExtNo'],
      fullLocationDetails: json['FullLocationDetails'],
      journalRefNo: json['JournalRefNo'],
      images: imagesList,
      productionLine: TextEditingController(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'TblAssetMasterEncodeAssetCaptureID': tblAssetMasterEncodeAssetCaptureID,
      'memberId': memberId,
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
      'subUser_id': subUserId,
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
    };

    if (images != null) {
      data['Images'] = images!.map((i) => i.toJson()).toList();
    }

    if (productionLine != null) {
      data['productionLine'] = productionLine!.text;
    }

    return data;
  }
}

class AssetImage {
  final String id;
  final String path;

  AssetImage({
    required this.id,
    required this.path,
  });

  factory AssetImage.fromJson(Map<String, dynamic> json) {
    return AssetImage(
      id: json['id']?.toString() ?? '',
      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
    };
  }
}
